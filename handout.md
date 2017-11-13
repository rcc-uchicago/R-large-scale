# Large-scale data analysis in R

**Research Computing Center Workshop**

November 13 & 14, 2017

Peter Carbonetto / 
Research Computing Center / 
University of Chicago / 
`pcarbo@uchicago.edu`

The main aim of this workshop is give you a solid footing for
transitioning from *interactive* (exploratory) data analysis in R to
*non-interactive* (automated) large-scale data analysis within a
high-performance computing environment. We will use the RCC's newest
and most powerful cluster, *midway2*. This will involve:

1. making most effective use of computational resources on the RCC
cluster (managing memory, using multiple CPUs simultaneously);

2. using R in combination with the SLURM job engine to run
hundreds of data analyses simultaneously.

During this workshop, we will work with the **RegMap data set**---this
data set contains genetic and climate variable data on *Arabidopsis
thaliana* collected by Joy Bergelson's lab at the University of
Chicago.

## Part 1: Warm-up with principal components analysis of the RegMap data

In this first part, we will interactively compute and visualize the
top principal components of the RegMap data set. During our
explorations, we will develop R and SLURM scripts to automate the
principal components analysis of this data set. We will use SLURM and
command-line tools to assess resource needs (time and memory).

**Exercise:** Based on the `htop` results, and the output from
`sacct`, what is the minimum amount of memory needed to run the PCA
analysis of the RegMap data? Please test your estimate by modifying
the requested memory in the SLURM script, and re-running it. Please
use the Etherpad to share your answers.

## Part 2: Implementing multithreaded computation in R for analysis of genetic adaptation to climate

In the first part, we used PCA to study structure in the *A. thaliana*
genetic data. Now, in the second part, we will study the connection
between the genetic data and the climate variables ("phenotypes").
Specifically, we will estimate the proportion of variance in each
climate variable that can be explained by the available genetic data
(abbreviated as "PVE"). This can be loosely interpreted as an
indicator of adaptation to climate; higher PVE estimates indicate
greater genetic adaptation.

**Exercise 1:** Here we will explore multithreading of matrix
operations (implemented in OpenBLAS) for computing the kinship matrix
and the weights:

+ Quit R, enter command `export OPENBLAS_NUM_THREADS=2` in the shell,
  then re-open R. What happens? Why does the computation get slower?

+ Next, start up a new `sinteractive` session, requesting 8 CPUs with
  the additional flag `--cpus-per-task=8`. How does the number of
  threads used in OpenBLAS affect compute time of the kinship matrix
  and the weights?

+ What effect does OpenBLAS multithreading have on memory usage?

Some tips:

+ Use `htop` in a separate session to examine memory usage and
  multithreading (look at the `CPU%` and `NLWP` columns).

+ For a more convenient way to set the number of OpenBLAS threads
  without having to restart your R session, use the provided R
  function `set.blas.num.threads`. To use this function, you will
  first need to build the `setblas` shared object (`.so`) library in
  the command-line shell, `R CMD SHLIB setblas.c`, then load the
  shared objects into R, `dyn.load("setblas.so")`. For example, to
  tell OpenBLAS to use 2 threads, type `set.blas.num.threads(2)` in R.

Please use the Etherpad to share your answers.

**Exercise 2:** In this exercise, we will interactively explore
parallel computation of the weights.

+ First set the number of OpenBLAS threads to 1. Try different values
  for the `nc` argument in function `compute.log.weights.multicore`.
  How does how does increasing the number of threads ("workers")
  affect compute time and memory? Use `htop` to assess this. What
  computational trade-off do you observe?

+ Based on your findings, how would you suggest setting the number of
  OpenBLAS and mclapply threads to make most effective use of
  computing resources?

Please use the Etherpad to share your answers.

**Exercise 3:** In this exercise, we will automate the data analysis
using a combination of R scripts and SLURM scripts.

+ First test script `run.all.pve.regmap.R` by running it on the first
  three phenotypes: `bio1_meant`, `bio2_diur_rng` and `bio3_isotherm`.

+ Modify the script `run.all.pve.regmap.R` so that it submits SLURM
  jobs to analyze all 48 phenotypes. Run this R script, and monitor
  its progress using `squeue --user=<cnetid>`.

+ What is the smallest mean PVE estimate for all 48 phenotypes? What
  is the largest?

+ Suppose that you would like a member of your project team to
  reproduce your analysis on the RCC cluster. What instructions would
  you give this person?

Please use the Etherpad to share your answers.
