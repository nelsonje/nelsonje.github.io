---
layout: post
title: "Git Reflog"
description: "Ever screw up a rebase and lose your branch? Ever wish you could easily undo that nightmare of a merge? This trick will let you undo the worst kind of errors: version control mess-ups."
---

This is actually a really simple tip. But I went quite a while using Git before learning this secret. The moral of the story is that Git, while it has one of the worst, most unintuitive command-line interfaces ever, really does save *almost everything* (okay, the one exception I can still think of is doing a `git checkout` and losing uncommitted changes).

Here's the situation I've found myself in countless times: I merged a branch, went through a bunch of hassle fixing conflicts, only to realize after I committed the merge that I had either merged the wrong branch, or had resolved conflicts the wrong way. This is actually not the end of the world. It's fairly straightforward to fix. Just find the last commit before the merge, and hard-reset the branch back to there:

```bash
$ git log --pretty=oneline --decorate --abbrev-commit --graph --branches="*"
*   6fd8675 (HEAD, master) Merge branch 'feature'
|\
| * d92be50 (feature) Implement feature.
* | c9a4be4 Another change.
|/
* f446a62 add another line
* 2601cd0 Initial commit.
$ git reset --hard HEAD~1
$ git log --pretty=oneline --decorate --abbrev-commit --graph --branches="*"
* c9a4be4 (HEAD, master) Another change.
| * d92be50 (feature) Implement feature.
|/
* f446a62 add another line
* 2601cd0 Initial commit.
```

Okay, so `git reset --hard HEAD~1` isn't exactly intuitive, but we undid the merge easily enough. However, what if you finished a rebase?

```bash
$ git checkout feature
$ git rebase master
First, rewinding head to replay your work on top of it...
Applying: Implement feature.
$ git log --pretty=oneline --decorate --abbrev-commit --graph --branches="*"
* 1df1f0f (HEAD, feature) Implement feature.
* c9a4be4 (master) Another change.
* f446a62 add another line
* 2601cd0 Initial commit.
```

It's not clear how to get that "feature" branch back, to undo all those new commits. The problem is we've lost our way to refer to the state of the branch before the rebase. The beauty of Git, however, is that those commits are not actually lost. The way to go back and find them is called the "reflog".

Every state your repo has ever been in is saved (at least for some time) in some shape or form. Usually we assign good names for these states, such as branches, or tags, or we refer to them by the commit which most recently modified them. However, even when git is making changes to branches based on some command, such as `rebase` or `merge`, it saves that state as well. These states, though no longer part of the branch, are accessible via the `reflog`.

```bash
$ git reflog
1df1f0f HEAD@{0}: rebase finished: returning to refs/heads/feature
1df1f0f HEAD@{1}: rebase: Implement feature.
c9a4be4 HEAD@{2}: rebase: checkout master
d92be50 HEAD@{3}: checkout: moving from master to feature
c9a4be4 HEAD@{4}: reset: moving to HEAD~1
6fd8675 HEAD@{5}: merge feature: Merge made by the 'recursive' strategy.
c9a4be4 HEAD@{6}: commit: Another change.
f446a62 HEAD@{7}: reset: moving to HEAD~1
d92be50 HEAD@{8}: checkout: moving from master to master
d92be50 HEAD@{9}: merge feature: Fast-forward
f446a62 HEAD@{10}: checkout: moving from feature to master
d92be50 HEAD@{11}: commit: Implement feature.
f446a62 HEAD@{12}: checkout: moving from master to feature
f446a62 HEAD@{13}: commit: add another line
2601cd0 HEAD@{14}: commit (amend): Initial commit.
fa8ba5f HEAD@{15}: commit (initial): test
```

Now we can see all of the operations that have been applied, including the rebase that I just did and want to undo (and even an additional "reset" I did after accidentally doing a fast-forward merge when setting up this situation).

To back up to before the bad rebase, all I have to do is find the SHA of the step I want to go back to (`d92be50`), and do a `reset`:

```bash
$ git reset --hard d92be50
HEAD is now at d92be50 Implement feature.
$ git log --pretty=oneline --decorate --abbrev-commit --graph --branches="*"
* c9a4be4 (HEAD, master) Another change.
| * d92be50 (feature) Implement feature.
|/
* f446a62 add another line
* 2601cd0 Initial commit.
```

This puts us back to where we were before the rebase, and if you check the reflog again, you'll see that we didn't even lose the failed rebase: it's all there in the history:

```bash
$ git reflog
d92be50 HEAD@{0}: reset: moving to d92be50
1df1f0f HEAD@{1}: rebase finished: returning to refs/heads/feature
1df1f0f HEAD@{2}: rebase: Implement feature.
c9a4be4 HEAD@{3}: rebase: checkout master
d92be50 HEAD@{4}: checkout: moving from master to feature
```

I hope this has helped reassure you that even when all seems lost, if you're using Git, there's probably a way out.

## Bonus tip: Legit

If you have ever made a commit message: "commit to merge", then this tip is for you.

The tool is called [Legit](http://www.git-legit.org). Legit adds some useful new commands that do things for you to help you avoid getting into situations like what I just described.

My favorite, which helps avoid the "commit to merge" situation, is `legit sync`, which does what the `Github for Mac` app does on "sync": stash any changes you've made, pull the latest (and rebase if the commits you have locally haven't been pushed), push your changes, and finally unstash your uncommitted changes.
