# Large-scale data analysis in R

The [R computing environment][R] has become an important tool for
quantitative research, from computational biology to financial
modeling. In this hands-on workshop, we will explore commonly used
strategies to efficiently analyze large-scale data sets in
R. Participants will learn to automate their R analyses on a compute
cluster, profile memory usage, call fast C++ routines in R, and
implement simple parallelization strategies, including multithreaded
and distributed computing. The aim is to learn these techniques
through hands-on "live coding"; we will analyze several medium to
large-scale data sets. Objectives: Attendees will (1) learn how to
automate R analyses on a compute cluster; (2) use simple techniques to
profile memory usage in R; (3) learn how to make more effective use of
memory in R; (4) use multithreading to speed up R computations; (5)
learn how to call C++ code from R using [Rcpp][Rcpp]; (6) write scripts to
distribute "embarrassingly parallel" R computations using the Slurm
job scheduler on the RCC Midway compute cluster; (7) learn through
"live coding."

## Prerequistes

All participants are expected to bring a laptop with a Mac, Linux or
Windows operating system. Further, participants should be comfortable
interacting with the UNIX shell and programming in a non-graphical R
environment (not RStudio). An RCC user account is recommended, but not
required.

## What's included

This git repository (the "workshop packet") includes:

+ [README.md](README.md): This file.

+ [conduct.md](conduct.md): Code of Conduct.

+ [LICENSE.md](license.md): License information for the materials in
  this repository.

+ [slides.pdf](slides.pdf): The slides for the workshop.

+ [slides.Rmd](slides.Rmd): R Markdown source used to generate these
  slides.

+ [Makefile](Makefile): GNU Makefile containing commands to
  generate the slides from the R Markdown source.

## Other information

+ This workshop attempts to apply elements of the
[Software Carpentry approach][swc]. See also
[this article][swc-lessons-learned]. Please also take a look at the
[Code of Conduct](conduct.md), and the
[license information](LICENSE.md).

+ To generate PDFs of the slides from the R Markdown source, run `make
slides` in the root directory of the git repository. For this to work,
you will need to to install the [rmarkdown][rmarkdown] package in R,
as well as the packages used in [slides.Rmd](slides.Rmd). For more
details, see the [Makefile](Makefile).

## Credits

These materials were developed by [Peter Carbonetto][peter] at the
[University of Chicago][uchicago]. Thank you to
[Matthew Stephens][matthew] for his support and guidance. Also thank
you to [Gao Wang][gao] for sharing the Python script for profiling memory
usage.

[R]: http://cran.r-project.org
[Rcpp]: https://cran.r-project.org/package=Rcpp
[uchicago]: https://www.uchicago.edu
[gao]: https://github.com/gaow
[peter]: http://pcarbo.github.io
[matthew]: http://stephenslab.uchicago.edu
[swc]: http://software-carpentry.org/lessons
[swc-lessons-learned]: http://dx.doi.org/10.12688/f1000research.3-62.v2
[rmarkdown]: https://cran.r-project.org/package=rmarkdown
