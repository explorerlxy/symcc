# Install script for directory: /home/caroulder/llvm-toolchain-10-10.0.0/llvm/unittests

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/opt/libcxx_symcc/x86_64")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/ADT/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Analysis/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/AsmParser/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/BinaryFormat/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Bitcode/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Bitstream/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/CodeGen/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/DebugInfo/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Demangle/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/ExecutionEngine/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Frontend/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/FuzzMutate/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/IR/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/LineEditor/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Linker/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/MC/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/MI/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Object/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/ObjectYAML/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Option/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Remarks/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Passes/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/ProfileData/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Support/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/TableGen/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Target/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/TextAPI/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/Transforms/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/XRay/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/64libcxx_symcc/unittests/tools/cmake_install.cmake")

endif()

