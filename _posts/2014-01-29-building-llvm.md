---
layout: post
title: Building LLVM on OSX
description: Notes from how I've built LLVM to be most useful for me.
---

I've had a lot of headaches building LLVM from source to suit my purposes. It's fairly straightforward to download a source distribution and get *something* built, but I've had to refine how I build LLVM so that things are setup to be useful for my workflow. Namely, I need:

- Release build with debug symbols so Grappa doesn't take forever to build.
- Assertions enabled so LLVM will catch bugs in my passes (disabled in Rel* builds)
- CMake module information for building LLVM passes out-of-source (comes from building using CMake)
- C++11 language/library support (`LLVM_ENABLE_CXX11`)

To build LLVM, I do the following (with, of course, `$prefix` replaced with the path):

```bash
$ cd llvm
$ mkdir -p build/Release
$ cd build/Release
$ cmake ../.. -GNinja \
    -DLLVM_ENABLE_CXX11=ON \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_INSTALL_PREFIX=$prefix \
    -DLLVM_ENABLE_ASSERTIONS=ON \
$ ninja
$ ninja install
```

On Linux, I add the following to ensure I build against a newer build of GCC:

```bash
-DGCC_INSTALL_PREFIX=$path_to_gcc48_install
```

On OSX, this flag isn't sufficient. No matter how I build it, it seems unable to find the standard headers. I debugged this issue using `clang`'s `-v` flag to get the list of include directories it's searching:

```bash
$ /opt/llvm/head/bin/clang++ -v -x c++ /dev/null -fsyntax-only
... elided some output ...
ignoring nonexistent directory "/usr/include/c++/v1"
#include "..." search starts here:
#include <...> search starts here:
 /opt/llvm/head/bin/../include/c++/v1
 /usr/local/include
 /opt/llvm/head/bin/../lib/clang/3.5/include
 /usr/include
 /System/Library/Frameworks (framework directory)
 /Library/Frameworks (framework directory)
End of search list.
```

Seeing that it's searching for the C++ standard headers in `/opt/llvm/head/include/c++/v1`, I simply sym-linked them from their actual location:

```bash
$ ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/c++/v1 $prefix/include/c++/v1
```

## Building my pass
Then to build my pass (out of source), I adapted something from [LLVM's CMake instructions](http://llvm.org/docs/CMake.html#cmake-out-of-source-pass), but to make sure I'm using the correct version of LLVM, I explicitly point it to the version built above:

```cmake
set( LLVM_DIR "${LLVM_ROOT}/share/llvm/cmake" )
set( CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${LLVM_DIR} )
find_package(LLVM)
include(AddLLVM)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_llvm_loadable_module( LLVMMyPass ${SOURCES} )
set_target_properties( LLVMMyPass PROPERTIES COMPILE_FLAGS "-fno-rtti" )
```

## Compiling other code using my pass
Finally, I have a special CMake macro for making executable that compile using my pass. 

An aside: I'm also using 

```cmake

get_property( MY_PASS_LIB TARGET LLVMMyPass  PROPERTY LOCATION )

macro(add_grappaclang_exe target)
  add_executable(${target} ${ARGN})
  add_dependencies(${target} LLVMMyPass)
  
  # make each of the individual .cpp files dependent on the 'compiler' target (my custom pass)
  set_source_files_properties(${ARGN} PROPERTIES
    OBJECT_DEPENDS LLVMMyPass
  )
  
  # load the 
  set_target_properties(${target} PROPERTIES
    COMPILE_FLAGS       "-Xclang -load -Xclang ${MY_PASS_LIB}"
  )
endmacro()
```

