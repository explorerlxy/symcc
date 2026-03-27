# Install script for directory: /home/caroulder/llvm-toolchain-10-10.0.0/llvm

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/opt/libcxx_symcc/i386")
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

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xllvm-headersx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES
    "/home/caroulder/llvm-toolchain-10-10.0.0/llvm/include/llvm"
    "/home/caroulder/llvm-toolchain-10-10.0.0/llvm/include/llvm-c"
    FILES_MATCHING REGEX "/[^/]*\\.def$" REGEX "/[^/]*\\.h$" REGEX "/[^/]*\\.td$" REGEX "/[^/]*\\.inc$" REGEX "/LICENSE\\.TXT$" REGEX "/\\.svn$" EXCLUDE)
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xllvm-headersx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES
    "/home/caroulder/TestSymCC/symcc/32libcxx_symcc/include/llvm"
    "/home/caroulder/TestSymCC/symcc/32libcxx_symcc/include/llvm-c"
    FILES_MATCHING REGEX "/[^/]*\\.def$" REGEX "/[^/]*\\.h$" REGEX "/[^/]*\\.gen$" REGEX "/[^/]*\\.inc$" REGEX "/CMakeFiles$" EXCLUDE REGEX "/config\\.h$" EXCLUDE REGEX "/\\.svn$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Demangle/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Support/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/TableGen/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/TableGen/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/include/llvm/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/FileCheck/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/PerfectShuffle/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/count/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/not/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/yaml-bench/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/projects/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/tools/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/runtimes/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/examples/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/lit/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/test/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/unittests/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/unittest/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/docs/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/cmake/modules/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/llvm-lit/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/benchmark/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/benchmarks/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/utils/llvm-locstats/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/caroulder/TestSymCC/symcc/32libcxx_symcc/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
