---
layout: post
title: LLVM Command line options
description: LLVM trick bonus round — command-line options. Admittedly dull-sounding but some serious C++ magic.
---

## Command-line options
Okay, command-line flags are not the most exiting topic ever. But, potentially pretty useful when you're making a complicated pass and want to [experiment](http://github.com/bholt/igor) with a bunch of different options. And I just have to say, this is some absolutely stunning C++ magic. I thought how LLVM smoothly handles strings with StringRef/Twine was impressive, but this is on a whole new level. But we'll start with the mundanes of actually using it in the simplest way possible.

Even when using the previously mentioned [trick]({% post_url 2014-01-30-llvm-quick-tricks %}) to run your pass with Clang, you can register your own command-line options to affect how it runs. For detailed instructions, refer to LLVM's excellent [CommandLine Manual](http://llvm.org/docs/CommandLine.html). The short version:

```cpp
#include <llvm/Support/CommandLine.h>

// declare a dead-simple command line flag
static cl::opt<bool> BeAwesome("awesome-mode", cl::desc("Enable super awesome extra feature."));
  
// later, in your code...
virtual void runOnFunction(Function &F) {
  if (BeAwesome) { /* ... */ }
}
```

```cpp
enum OptLevel {
  Debug, O1, O2, O3
};

cl::opt<OptLevel> OptimizationLevel(cl::desc("Choose optimization level:"),
  cl::values(
   clEnumValN(Debug, "g", "No optimizations, enable debugging"),
    clEnumVal(O1        , "Enable trivial optimizations"),
    clEnumVal(O2        , "Enable default optimizations"),
    clEnumVal(O3        , "Enable expensive optimizations"),
   clEnumValEnd));
```

Hats off to the some of the best C++ code around.
