// This file is part of SymCC.
//
// SymCC is free software: you can redistribute it and/or modify it under the
// terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// SymCC is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with
// SymCC. If not, see <https://www.gnu.org/licenses/>.

#include "Pass.h"

#include <llvm/ADT/SmallVector.h>
#include <llvm/CodeGen/IntrinsicLowering.h>
#include <llvm/CodeGen/TargetLowering.h>
#include <llvm/CodeGen/TargetSubtargetInfo.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Target/TargetMachine.h>
#include <llvm/Target/TargetOptions.h>
#include <llvm/Transforms/Utils/ModuleUtils.h>

#if LLVM_VERSION_MAJOR < 14
#include <llvm/Support/TargetRegistry.h>
#else
#include <llvm/MC/TargetRegistry.h>
#endif

#include "Runtime.h"
#include "Symbolizer.h"

using namespace llvm;

#ifndef NDEBUG
#define DEBUG(X)                                                               \
  do {                                                                         \
    X;                                                                         \
  } while (false)
#else
#define DEBUG(X) ((void)0)
#endif

char SymbolizeLegacyPass::ID = 0;

namespace {

static constexpr char kSymCtorName[] = "__sym_ctor";

bool instrumentModule(Module &M) {
  DEBUG(errs() << "Symbolizer module instrumentation\n");

  LLVMContext &C = M.getContext();
  IntegerType *Int8Ty  = IntegerType::getInt8Ty(C);
  IntegerType *Int32Ty = IntegerType::getInt32Ty(C);
  
  /* Get globals for the SHM region and the previous location. Note that
     __afl_prev_loc is thread-local. */

  GlobalVariable *AFLMapPtr = new GlobalVariable(
      M, PointerType::get(Int8Ty, 0), false,
      GlobalValue::ExternalLinkage, 0, "__afl_area_ptr");

  GlobalVariable *AFLPrevLoc = new GlobalVariable(
      M, Int32Ty, false, GlobalValue::ExternalLinkage, 0, "__afl_prev_loc",
      0, GlobalVariable::GeneralDynamicTLSModel, 0, false);

  llvm::appendToUsed(M, {AFLMapPtr, AFLPrevLoc});

  // Redirect calls to external functions to the corresponding wrappers and
  // rename internal functions.
  for (auto &function : M.functions()) {
    auto name = function.getName();
    if (isInterceptedFunction(function))
      function.setName(name + "_symbolized");
  }

  // Insert a constructor that initializes the runtime and any globals.
  Function *ctor;
  // std::tie(ctor, std::ignore) = createSanitizerCtorAndInitFunctions(
  //     M, kSymCtorName, "__afl_auto_init", {}, {});
  // appendToGlobalCtors(M, ctor, 0);
  
  std::tie(ctor, std::ignore) = createSanitizerCtorAndInitFunctions(
      M, kSymCtorName, "_sym_initialize", {}, {});
  appendToGlobalCtors(M, ctor, 0);

  std::tie(ctor, std::ignore) = createSanitizerCtorAndInitFunctions(
      M, kSymCtorName, "__afl_auto_init", {}, {});
  appendToGlobalCtors(M, ctor, 0);

  return true;
}

bool canLower(const CallInst *CI) {
  const Function *Callee = CI->getCalledFunction();
  if (!Callee)
    return false;

  switch (Callee->getIntrinsicID()) {
  case Intrinsic::expect:
  case Intrinsic::ctpop:
  case Intrinsic::ctlz:
  case Intrinsic::cttz:
  case Intrinsic::prefetch:
  case Intrinsic::pcmarker:
  case Intrinsic::dbg_declare:
  case Intrinsic::dbg_label:
  case Intrinsic::eh_typeid_for:
  case Intrinsic::annotation:
  case Intrinsic::ptr_annotation:
  case Intrinsic::assume:
#if LLVM_VERSION_MAJOR > 11
  case Intrinsic::experimental_noalias_scope_decl:
#endif
  case Intrinsic::var_annotation:
  case Intrinsic::sqrt:
  case Intrinsic::log:
  case Intrinsic::log2:
  case Intrinsic::log10:
  case Intrinsic::exp:
  case Intrinsic::exp2:
  case Intrinsic::pow:
  case Intrinsic::sin:
  case Intrinsic::cos:
  case Intrinsic::floor:
  case Intrinsic::ceil:
  case Intrinsic::trunc:
  case Intrinsic::round:
#if LLVM_VERSION_MAJOR > 10
  case Intrinsic::roundeven:
#endif
  case Intrinsic::copysign:
#if LLVM_VERSION_MAJOR < 16
  case Intrinsic::flt_rounds:
#else
  case Intrinsic::get_rounding:
#endif
  case Intrinsic::invariant_start:
  case Intrinsic::lifetime_start:
  case Intrinsic::invariant_end:
  case Intrinsic::lifetime_end:
    return true;
  default:
    return false;
  }

  llvm_unreachable("Control cannot reach here");
}

void liftInlineAssembly(CallInst *CI) {
  // TODO When we don't have to worry about the old pass manager anymore, move
  // the initialization to the pass constructor. (Currently there are two
  // passes, but only if we're on a recent enough LLVM...)

  Function *F = CI->getFunction();
  Module *M = F->getParent();
  auto triple = M->getTargetTriple();

  std::string error;
  auto target = TargetRegistry::lookupTarget(triple, error);
  if (!target) {
    errs() << "Warning: can't get target info to lift inline assembly\n";
    return;
  }

  auto cpu = F->getFnAttribute("target-cpu").getValueAsString();
  auto features = F->getFnAttribute("target-features").getValueAsString();

  std::unique_ptr<TargetMachine> TM(
      target->createTargetMachine(triple, cpu, features, TargetOptions(), {}));
  auto subTarget = TM->getSubtargetImpl(*F);
  if (subTarget == nullptr)
    return;

  auto targetLowering = subTarget->getTargetLowering();
  if (targetLowering == nullptr)
    return;

  targetLowering->ExpandInlineAsm(CI);
}

bool instrumentFunction(Function &F) {
  auto functionName = F.getName();
  if (functionName == kSymCtorName)
    return false;

  DEBUG(errs() << "Symbolizing function ");
  DEBUG(errs().write_escaped(functionName) << '\n');

  SmallVector<Instruction *, 0> allInstructions;
  allInstructions.reserve(F.getInstructionCount());
  for (auto &I : instructions(F))
    allInstructions.push_back(&I);

  IntrinsicLowering IL(F.getParent()->getDataLayout());
  for (auto *I : allInstructions) {
    if (auto *CI = dyn_cast<CallInst>(I)) {
      if (canLower(CI)) {
        IL.LowerIntrinsicCall(CI);
      } else if (isa<InlineAsm>(CI->getCalledOperand())) {
        liftInlineAssembly(CI);
      }
    }
  }

  allInstructions.clear();
  for (auto &I : instructions(F))
    allInstructions.push_back(&I);
  
  Symbolizer symbolizer(*F.getParent());
  symbolizer.symbolizeFunctionArguments(F);

  for (auto &basicBlock : F)
    symbolizer.insertBasicBlockNotification(basicBlock);

  for (auto *instPtr : allInstructions)
    symbolizer.visit(instPtr);

  symbolizer.finalizePHINodes();
  symbolizer.shortCircuitExpressionUses();

  // DEBUG(errs() << F << '\n');
  assert(!verifyFunction(F, &errs()) &&
         "SymbolizePass produced invalid bitcode");
  
  // -----------------------------------------------------------------------------
  // AFL coverage instrument
  Module &M = (*F.getParent());
  LLVMContext &C = M.getContext();
  IntegerType *Int8Ty  = IntegerType::getInt8Ty(C);
  IntegerType *Int32Ty = IntegerType::getInt32Ty(C);
  
  /* Get globals for the SHM region and the previous location. Note that
     __afl_prev_loc is thread-local. */

  GlobalVariable *AFLMapPtr = M.getGlobalVariable("__afl_area_ptr");

  GlobalVariable *AFLPrevLoc = M.getGlobalVariable("__afl_prev_loc");

  if (!AFLMapPtr || !AFLPrevLoc) {
  errs() << "Error: Missing global variables __afl_area_ptr or __afl_prev_loc\n";
  return false;
}

  // Reference of Global Variables for Edge-BranCond Mapping.
  // GlobalVariable *CondJmp = M.getGlobalVariable("__cond_jmp");

  // GlobalVariable *BranCond = M.getGlobalVariable("__bran_cond");

  for (auto &BB : F) {
    BasicBlock::iterator IP = BB.getFirstInsertionPt();
    IRBuilder<> IRB(&(*IP));
    /* Make up cur_loc */

    unsigned int cur_loc = AFL_R(MAP_SIZE);
    ConstantInt *CurLoc = ConstantInt::get(Int32Ty, cur_loc);

    /* Load prev_loc */

    LoadInst *PrevLoc = IRB.CreateLoad(AFLPrevLoc);
    PrevLoc->setMetadata(M.getMDKindID("nosanitize"), MDNode::get(C, None));
    Value *PrevLocCasted = IRB.CreateZExt(PrevLoc, IRB.getInt32Ty());

    /* Load SHM pointer */

    LoadInst *MapPtr = IRB.CreateLoad(AFLMapPtr);
    MapPtr->setMetadata(M.getMDKindID("nosanitize"), MDNode::get(C, None));
    Value *MapPtrIdx =
        IRB.CreateGEP(MapPtr, IRB.CreateXor(PrevLocCasted, CurLoc));

    /* Update bitmap */

    LoadInst *Counter = IRB.CreateLoad(MapPtrIdx);
    Counter->setMetadata(M.getMDKindID("nosanitize"), MDNode::get(C, None));
    Value *Incr = IRB.CreateAdd(Counter, ConstantInt::get(Int8Ty, 1));
    IRB.CreateStore(Incr, MapPtrIdx)
        ->setMetadata(M.getMDKindID("nosanitize"), MDNode::get(C, None));

    /* Set prev_loc to cur_loc >> 1 */

    StoreInst *Store =
        IRB.CreateStore(ConstantInt::get(Int32Ty, cur_loc >> 1), AFLPrevLoc);
    Store->setMetadata(M.getMDKindID("nosanitize"), MDNode::get(C, None));

    /* Save the branch condition to path constraint set */ 

  }

  return true;
}

} // namespace

bool SymbolizeLegacyPass::doInitialization(Module &M) {
  return instrumentModule(M);
}

bool SymbolizeLegacyPass::runOnFunction(Function &F) {
  return instrumentFunction(F);
}

#if LLVM_VERSION_MAJOR >= 13

PreservedAnalyses SymbolizePass::run(Function &F, FunctionAnalysisManager &) {
  return instrumentFunction(F) ? PreservedAnalyses::none()
                               : PreservedAnalyses::all();
}

PreservedAnalyses SymbolizePass::run(Module &M, ModuleAnalysisManager &) {
  return instrumentModule(M) ? PreservedAnalyses::none()
                             : PreservedAnalyses::all();
}

#endif
