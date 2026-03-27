/*
  Copyright 2015 Google LLC All rights reserved.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at:

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

/*
   american fuzzy lop - LLVM instrumentation bootstrap
   ---------------------------------------------------

   Written by Laszlo Szekeres <lszekeres@google.com> and
              Michal Zalewski <lcamtuf@google.com>

   LLVM integration design comes from Laszlo Szekeres.

   This code is the rewrite of afl-as.h's main_payload.
*/

// #include "../android-ashmem.h"
// #include "../config.h"
// #include "../types.h"
extern "C" {
  #include <stdio.h>
  #include <stdlib.h>
  #include <signal.h>
  #include <unistd.h>
  #include <string.h>
  #include <assert.h>
  #include <stdint.h>
  #include <stdbool.h>

  #include <sys/mman.h>
  #include <sys/shm.h>
  #include <sys/wait.h>
  #include <sys/types.h>
}
#include <Config.h>

/* This is a somewhat ugly hack for the experimental 'trace-pc-guard' mode.
   Basically, we need to make sure that the forkserver is initialized after
   the LLVM-generated runtime initialization pass, not before. */


#define FORKSRV_FD          198
#define MAP_SIZE_POW2       16
#define MAP_SIZE            (1 << MAP_SIZE_POW2)
#define SHM_ENV_VAR         "__AFL_SHM_ID"
#define DEFER_ENV_VAR       "__AFL_DEFER_FORKSRV"
#define SHM_SYMBOLIC_ENV_VAR                         "__AFL_SHM_SYMBOLIC_ENV_ID"
#define SHM_OUT_DIR_ENV_VAR                         "__AFL_SHM_OUTDIR_ENV_ID"
#define SHM_QUEUE_ENTRY_ID_ENV_VAR                  "__AFL_SHM_QUEUE_ENTRY_ID"
#define SHM_INSERT_DEPTH_ENV_VAR                    "__AFL_SHM_INSERT_DEPTH__ID"

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;

typedef int8_t   s8;
typedef int16_t  s16;
typedef int32_t  s32;
typedef int64_t  s64;
extern struct Config g_config;

/* Globals needed by the injected instrumentation. The __afl_area_initial region
   is used for instrumentation output before __afl_map_shm() has a chance to run.
   It will end up as .comm, so it shouldn't be too wasteful. */

// __afl_area_initial的长度必须为MAP_SIZE，因为插桩代码的基本块ID是[0, MAP_SIZE），否则可能会导致越届崩溃。
u8  __afl_area_initial[MAP_SIZE];
u8* __afl_area_ptr = __afl_area_initial;
u8* __out_dir = __afl_area_initial;
u8* __symbolic = __afl_area_initial;

u32* __queue_entry_id = (u32*)__afl_area_initial;
u32* __insert_depth = (u32*)__afl_area_initial;

__thread u32 __afl_prev_loc = 0;

// Definition of Global Variables for Edge-BranCond Mapping.
// __thread bool __cond_jmp = false;
// __thread u8* __bran_cond = NULL;


/* SHM setup. */

static void __afl_map_shm(void) {

  char *id_str = getenv(SHM_ENV_VAR);

  /* If we're running under AFL, attach to the appropriate region, replacing the
     early-stage __afl_area_initial region that is needed to allow some really
     hacky .init code to work correctly in projects such as OpenSSL. */

  if (id_str) {

    u32 shm_id = atoi(id_str);

    __afl_area_ptr = (u8*)shmat(shm_id, NULL, 0);

    if (__afl_area_ptr == (void *)-1) _exit(1);

    __afl_area_ptr[0] = 1;

  }
  else{
    printf("No __afl_area_ptr provided.\n");
    _exit(1);
  }
}

static void __afl_out_dir_shm(void) {

  char *id_str = getenv(SHM_OUT_DIR_ENV_VAR);

  if (id_str) {

    u32 shm_id = atoi(id_str);

    __out_dir = (u8*)shmat(shm_id, NULL, 0);

    if (__out_dir == (void *)-1) _exit(1);

  }
  else{
    printf("No __out_dir provided.\n");
    _exit(1);
  }
}

static void __afl_symbolic_id_shm(void) {

  char *id_str = getenv(SHM_SYMBOLIC_ENV_VAR);

  if (id_str) {

    u32 shm_id = atoi(id_str);

    __symbolic = (u8*)shmat(shm_id, NULL, 0);

    if (__symbolic == (void *)-1) _exit(1);

  }
  else{
    printf("No __symbolic provided.\n");
    _exit(1);
  }
}
static void __afl_queue_entry_id_shm(void) {

  char *id_str = getenv(SHM_QUEUE_ENTRY_ID_ENV_VAR);

  if (id_str) {

    u32 shm_id = atoi(id_str);

    __queue_entry_id = (u32*)shmat(shm_id, NULL, 0);

    if (__queue_entry_id == (void *)-1) _exit(1);

  }
  else{
    printf("No __queue_entry_id provided.\n");
    _exit(1);
  }
}

static void __afl_insert_depth_shm(void) {

  char *id_str = getenv(SHM_INSERT_DEPTH_ENV_VAR);

  if (id_str) {

    u32 shm_id = atoi(id_str);

    __insert_depth = (u32*)shmat(shm_id, NULL, 0);

    if (__insert_depth == (void *)-1) _exit(1);

  }
  else{
    printf("No __insert_depth provided.\n");
    _exit(1);
  }
}

static void reset_gconfig(void) {

  switch(*__symbolic) {
    case 0:
      g_config.input = NoInput{};
      break;
    case 1:
      g_config.input = StdinInput{};
      break;
    case 2:
      g_config.input = MemoryInput{};
      break;
    case 3:
      g_config.input = FileInput{};
      break;
    default:
      printf("Invalid input type.\n");
      _exit(1);
  }
}

/* Fork server logic. */

static void __afl_start_forkserver(void) {

  static u8 tmp[4];
  s32 child_pid;


  /* Phone home and tell the parent that we're OK. If parent isn't there,
     assume we're not running in forkserver mode and just execute program. */

  if (write(FORKSRV_FD + 1, tmp, 4) != 4) return;

  while (1) {

    u32 was_killed;
    int status;

    /* Wait for parent by reading from the pipe. Abort if read fails. */

    if (read(FORKSRV_FD, &was_killed, 4) != 4) _exit(1);



      /* Once woken up, create a clone of our process. */
    reset_gconfig();
    child_pid = fork();
    if (child_pid < 0) _exit(1);

    /* In child process: close fds, resume execution. */

    if (!child_pid) {

      close(FORKSRV_FD);
      close(FORKSRV_FD + 1);
      return;

    }


    /* In parent process: write PID to pipe, then wait for child. */

    if (write(FORKSRV_FD + 1, &child_pid, 4) != 4) _exit(1);

    if (waitpid(child_pid, &status, 0) < 0)
      _exit(1);


    /* Relay wait status to pipe, then loop back. */

    if (write(FORKSRV_FD + 1, &status, 4) != 4) _exit(1);

  }

}


/* This one can be called from user code when deferred forkserver mode
    is enabled. */

void __afl_manual_init(void) {

  static u8 init_done;

  if (!init_done) {

    __afl_map_shm();
    __afl_queue_entry_id_shm();
    __afl_symbolic_id_shm();
    __afl_insert_depth_shm();
    __afl_out_dir_shm();
    __afl_start_forkserver();
    init_done = 1;

  }

}


/* Proper initialization routine. */

void __afl_auto_init(void) {

  if (getenv(DEFER_ENV_VAR)) return;

  __afl_manual_init();

}

