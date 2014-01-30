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
