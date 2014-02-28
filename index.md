---
layout: default
title: Home
tagline: University of Washington
---

<!-- ![profile](img/brandon_coast.jpg) -->
<div class="span5 pull-right" style="padding-left:20px">
  <div>
    <img src="img/brandon_coast.jpg" class="img-rounded"/>
  </div>
</div>

## About Me
I am a grad student at the University of Washington, pursuing a PhD in Computer Science and Engineering. My research interests include exploring programming models, languages, and compilers for the purposes of exposing and expressing parallelism in a way that existing architectures can use it. My research is done as part of the Computer Architecture group at UW ([Sampa](http://sampa.cs.washington.edu)), with co-advisors [Luis Ceze](http://www.cs.washington.edu/homes/luisceze/) and [Mark Oskin](http://www.cs.washington.edu/homes/oskin). With them, I am working on the [Grappa](http://grappa.io) project, an effort to improve performance of irregular applications on commodity clusters in software.

## Research Interests
I'm interested in helping people solve tough problems using the most powerful computer they have available. 

Right now, the *tough problems* people seem to be facing involve analyzing and understanding large, irregular data sets (including such "Big Data" problems as social network analytics). These problems are particularly challenging because their execution is highly data-dependent and unpredictable, wreaking havoc on systems which are optimized for regular access patterns.

For many people---in particular, most data scientists---the *most powerful computer* they have access to is actually pretty beefy: a compute cluster, even if it's just an on-demand cluster from the cloud. These highly-parallel distributed-memory machines are notoriously difficult to do useful things with.

Solving these problems requires being willing to change any part of the traditional "stack": hardware, compiler, runtime, programming language, or tools. I enjoy hacking LLVM to automatically extract communication, develop fancy C++11 interfaces to runtimes, and exploring how to leverage high-level program information to optimize low-level runtime calls.

## Projects
Read more about various work in progress and past on the [Projects](projects.html) page. A few highlights:

* [Grappa](projects.html#Grappa): Picking up the slack in commodity clusters for irregular applications.
* [Igor](projects.html#Igor): A system to make it easier to run parameter sweeps and collect data from experiments.

## Personal
Despite appearances, in addition to locking myself up in a room coding all day, I do other things as well. I enjoy hiking, soccer, frisbee, and sci-fi. I particularly like mountains, in which Washington is not disappointing me.


<!-- <div class="container">
 <div class="fluid-row">
    <div class="span7">

    </div>
    <div class="span4">
      <img src="img/brandon_coast.jpg" class="img-polaroid" style="height=100px"/>
      <ul class="thumbnails">
        <li></li>
        <li class="span4">
          <div class="alert alert-info">
            <h1>GitHub</h1>
            <a class="btn" href="http://github.com/bholt">See my repos &raquo;</a>
          </div>
        </li>
      </ul>
    </div>
  </div>
</div> -->
