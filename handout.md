# Large-scale data analysis in R

November 13 & 14, 2017
Research Computing Center Workshop
University of Chicago

The main aim of this workshop is give you a solid footing for
transitioning from *interactive* (exploratory) data analysis in R to
*non-interactive* (automated) large-scale data analysis within a
high-performance computing environment (specifically, the RCC's newest
and most powerful cluster, *midway2*). This will involve:

1. making most effective use of computational resources on the RCC
cluster (managing memory, parallel/multithreaded computing);

2. using R in combination with the SLURM job engine to run
hundreds of data analyses simultaneously.

During this workshop, we will work with the
[RegMap data set](http://bergelson.uchicago.edu/?page_id=790)---genetic
and climate variable data on *Arabidopsis thaliana* collected by Joy
Bergelson's lab at the University of Chicago.

## Part 1: Warm-up with principal components analysis of the RegMap data

In this first part, we will interactively compute and visualize the top
principal components of the RegMap data set. During our explorations,
we will develop an R script, as well as a SLURM script to automate the
principal components analysis of this data set. We will use SLURM and
command-line tools to assess resource needs (time and memory).

*Exercise:* Based on the `htop` results, and the output from `sacct`,
what is the minimum amount of memory needed to run the PCA analysis
ofthe RegMap data? Please test your estimate by modifying the
requested memory in the SLURM script, and re-running it. Please use
the Etherpad to share your answers.

## Part 2: Implementing multithreaded computation in R for analysis of genetic adaptation to climate

In the first part, we use PCA to study structure in the *A. thaliana*
genetic data. In the second part, we will study the connection between
the genetic data and the climate variables ("phenotypes").
Specifically, we will estimate the proportion of variance in each
climate variable that can be explained by the available genetic data
(abbreviated as "PVE"). This can be loosely interpreted as an
indicator of adaptation to climate; higher PVE estimates indicate
greater genetic adaptation.
