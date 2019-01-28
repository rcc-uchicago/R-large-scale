# Large-scale data analysis in R

The [R computing environment][R] computing environment has become an
important tool for quantitative research, from computational biology
to financial modeling. In this hands-on workshop, we will explore
commonly used strategies to efficiently analyze large-scale data sets
in R. Participants will learn to automate their R analyses on a
compute cluster, profile memory usage, call fast C++ routines in R,
and implement simple parallelization strategies, including
multithreaded and distributed computing. The aim is to learn these
techniques through hands-on “live coding”; we will analyze several
medium to large-scale data sets.

## Prerequistes

All participants are expected to bring a laptop with a Mac, Linux or
Windows operating system. Further, participants should be comfortable
interacting with the UNIX shell and programming in a non-graphical R
environment (*i.e.*, not RStudio). An RCC user account is recommended,
but not required.

## What's included

This git repository (the "workshop packet") includes:

+ [README.md](README.md): This file.

+ *Add info about the most important files here.*

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

+ See also the [instructor notes](docs/NOTES.md).

## Credits

These materials were developed by [Peter Carbonetto][peter] at the
[University of Chicago][uchicago]. Thank you to
[Matthew Stephens][matthew] for his support and guidance. Also thank
you to [Gao Wang][gao] for sharing the Python script for profiling memory
usage.

[R]: http://cran.r-project.org
[uchicago]: https://www.uchicago.edu
[gao]: https://github.com/gaow
[peter]: http://pcarbo.github.io
[matthew]: http://stephenslab.uchicago.edu
[swc]: http://software-carpentry.org/lessons
[swc-lessons-learned]: http://dx.doi.org/10.12688/f1000research.3-62.v2
[rmarkdown]: https://cran.r-project.org/package=rmarkdown
