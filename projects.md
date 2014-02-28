---
layout: default
title: Projects
description: List of current and recent research and side projects.
---

<a name="Grappa"></a>
## [Grappa](http://grappa.io)
<img src="img/grappa-grapes.jpg" class="img-thumbnail pull-right" style="width:250px;margin:15px"/>
Scaling irregular applications on commodity hardware.

Irregular applications are those that do lots of hard-to-predict, data-dependent, fine-grained memory accesses. Examples include graph analytics, molecular dynamics, circuit simulation, neuromorphic computation, and many more. The lack of spatial and temporal locality in these applications makes it difficult to scale them beyond a single node because commodity networks need large packets to get near their peak throughput. The goal of this project is to make it easier to develop and run those kinds of applications on large compute clusters. We see the same few tricks being implemented over and over when irregular applications are tuned for maximum performance, such as rewriting parts to buffer communication, using asynchronous callbacks to overlap communication and disk I/O with computation. In addition to being wasteful, this process can be error-prone.

The core is a runtime system we are developing that automatically aggregates small messages to improve network bandwidth, using massive multithreading to tolerate the increased latency. All we ask is that the programmer expose *sufficient parallelism*, a quantity that is not lacking in these "Big Data" applications. Our highly-optimized runtime can then manage moving data and computation around the cluster, performing tricks such as issuing hardware pre-fetches and carefully managing the L1 cache, performing extremely lightweight context switches, and coordinating RDMA transfers to get maximum throughput on the network.

A full list of publications for this project and more information can be found on our project website: [grappa.io](http://grappa.io).

Grappa is also now **open source**! We would love to help people try it out on their own problems. Check it out on [Github](http://github.com/uwsampa/grappa).

A couple sub-projects related to Grappa that I've worked on are listed below.

### Flat combining
The general idea is that synchronization on global shared data structures can be massively improved by waiting and combining many operations together, and Grappa's massive multithreading allows us to tolerate this additional latency.

- *Flat Combining Synchronized Global Data Structures* — presented at [PGAS'13](http://www.pgas2013.org.uk) ([paper](pubs/holt-pgas13.pdf), [slides](pubs/holt-pgas13-slides.pdf))
- *Turning Contention Into Cooperation* - UW CSE Qualifying Examination Talk ([slides](pubs/holt-quals.pdf))

### Task migration simulation
[Brandon Myers](http://www.cs.washington.edu/homes/bdmyers/) and I submitted a workshop paper to [HotPar '12](https://www.usenix.org/conference/hotpar12) exploring whether it is possible to make profitable predictions about when to move a task its the data (migration) rather than moving the data. Our study involved instrumenting the shared memory accesses in a few simple benchmarks, collecting an execution trace, and simulating the cost of data movement under different migration policies, including an optimal migration schedule.

- *Do we need a crystal ball for task migration?* — presented at [HotPar'12](https://www.usenix.org/conference/hotpar12) ([paper](https://www.usenix.org/system/files/conference/hotpar12/hotpar12-final46.pdf))

---

<a name="Igor"></a>
## Tools
### [Igor](http://github.com/bholt/igor)
<img src="img/mini-igor.jpg" class="img-thumbnail pull-right" style="width:250px;margin:15px"/>

This project was born out of necessity when we wanted to be able to collect output from many experiments in Grappa and related projects. We also needed a way to easily enumerate a large multi-variate parameter space, especially when trying to find the right parameters to maximize performance for Grappa. This script aims to help with generating a large number of experiments, parsing their output, and storing experiment inputs and outcomes to a SQLite database automatically. For now, it simply supports having a static script that runs all the experiments in a single batch and gathers the results automatically. We would like to make the experience more interactive, where a prompt can be used to schedule new parameter sweeps, monitor progress of existing experiments, inspect gathered data points, and visualize preliminary results. A complete re-write to support this goal will probably happen--eventually.


---

### [Project Archive](old_projects.html)
