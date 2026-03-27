# Install script for directory: /home/caroulder/llvm-toolchain-10-10.0.0/llvm/lib

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

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/IR/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/FuzzMutate/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/IRReader/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/CodeGen/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/BinaryFormat/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Bitcode/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Bitstream/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/DWARFLinker/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Frontend/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Transforms/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Linker/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Analysis/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/LTO/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/MC/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/MCA/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Object/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/ObjectYAML/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Option/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Remarks/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/DebugInfo/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/ExecutionEngine/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Target/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/AsmParser/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/LineEditor/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/ProfileData/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Passes/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/TextAPI/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/ToolDrivers/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/XRay/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/Testing/cmake_install.cmake")
  include("/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/WindowsManifest/cmake_install.cmake")

endif()

