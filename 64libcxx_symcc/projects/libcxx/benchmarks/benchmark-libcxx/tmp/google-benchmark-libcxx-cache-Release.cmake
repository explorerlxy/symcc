
set(CMAKE_C_COMPILER "/home/caroulder/TestSymCC/symcc/simple32build/symcc" CACHE STRING "Initial cache" FORCE)
set(CMAKE_CXX_COMPILER "/home/caroulder/TestSymCC/symcc/simple32build/sym++" CACHE STRING "Initial cache" FORCE)
set(CMAKE_BUILD_TYPE "RELEASE" CACHE STRING "Initial cache" FORCE)
set(CMAKE_INSTALL_PREFIX "/home/caroulder/TestSymCC/symcc/64libcxx_symcc/projects/libcxx/benchmarks/benchmark-libcxx" CACHE PATH "Initial cache" FORCE)
set(CMAKE_CXX_FLAGS "-Wno-unused-command-line-argument -nostdinc++ -isystem /home/caroulder/llvm-toolchain-10-10.0.0/libcxx/include -L/home/caroulder/TestSymCC/symcc/64libcxx_symcc/./lib -Wl,-rpath,/home/caroulder/TestSymCC/symcc/64libcxx_symcc/./lib -L -Wl,-rpath," CACHE STRING "Initial cache" FORCE)
set(BENCHMARK_USE_LIBCXX "ON" CACHE BOOL "Initial cache" FORCE)
set(BENCHMARK_ENABLE_TESTING "OFF" CACHE BOOL "Initial cache" FORCE)