---
layout: post
title: Quick LLVM Tricks
description: Reiterating a trick I learned for registering LLVM passes automatically with Clang, rather than needing to go through `opt`, and some other gems.
---

## Registering passes automatically.
My colleague [Adrian Sampson](http://homes.cs.washington.edu/~asampson) showed me a really good trick for running LLVM passes automatically, and luckily he wrote a really nice [blog post about it](http://homes.cs.washington.edu/~asampson/blog/clangpass.html).

I won't steal his thunder, but I will just mention that this has come in handy for me. And because my project uses C++11 throughout, I thought I'd point out that you can make it ever-so-slightly prettier with a lambda which is automatically coerced to a function pointer:

```cpp
/////////////////////////////////////////////////////////////////////////
// Register as default pass, to run before any other optimization passes
static RegisterStandardPasses MyPassRegistration(PassManagerBuilder::EP_EarlyAsPossible,
  [](const PassManagerBuilder&, PassManagerBase& PM) {
    errs() << "Registered pass!\n";
    PM.add(new MyPass());
  });
```

