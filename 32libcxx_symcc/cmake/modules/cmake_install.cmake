# Install script for directory: /home/caroulder/llvm-toolchain-10-10.0.0/llvm/cmake/modules

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

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xcmake-exportsx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/llvm" TYPE FILE FILES
    "/home/caroulder/TestSymCC/symcc/32libcxx_symcc/cmake/modules/CMakeFiles/LLVMConfig.cmake"
    "/home/caroulder/TestSymCC/symcc/32libcxx_symcc/lib/cmake/llvm/LLVMConfigVersion.cmake"
    "/home/caroulder/llvm-toolchain-10-10.0.0/llvm/cmake/modules/LLVM-Config.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xcmake-exportsx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/cmake/llvm" TYPE DIRECTORY FILES "/home/caroulder/llvm-toolchain-10-10.0.0/llvm/cmake/modules/." FILES_MATCHING REGEX "/[^/]*\\.cmake$" REGEX "/\\.svn$" EXCLUDE REGEX "/LLVMConfig\\.cmake$" EXCLUDE REGEX "/LLVMConfigVersion\\.cmake$" EXCLUDE REGEX "/LLVM\\-Config\\.cmake$" EXCLUDE REGEX "/GetHostTriple\\.cmake$" EXCLUDE)
endif()

