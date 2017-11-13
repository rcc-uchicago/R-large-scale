# Instructor notes

* Slides:
    - Title (with github repo URL)
	- Outline
    - Aims

## Instructor in-class setup

+ Arrange chairs and tables.
+ Clean up Desktop.
+ Use Terminal, not iTerm.
+ Use a font that better distinguishes commas and periods.
+ Distribute Yubikeys.
+ Distrbute sticky notes.

## Part 1: Analysis of genetic data---interactive and non-interactive

Create two sessions on midway2: one for loading up an R environment,
and a second for developing code (e.g., in emacs).

Create an interactive session for 2 hours on midway2. It is useful to
create a screen session in case you lose your connection at any
point. *Also motivate use of sinteractive by running htop on login
node.*

```bash
screen -S workshop
cd R-large-scale/code
sinteractive --partition=broadwl --time=2:00:00 --reservation=rworkshop
module load R/3.4.1
R
getwd()
```

Develop `pca.regmap.R` code from scratch, while trying out code
interactively in R. In doing so, explore resource usage (CPU time,
memory).

Make some refinements to the script so that it is ready to run
non-interactively. Then test the script with

```R
rm(list = ls())
source("pca.regmap.R")
```

Next, develop `pca_regmap.sbatch` from scratch.

Submit a SLURM job using our sbatch script. While it is running, here
are a few of the things we can do to monitor progress of the script:

```bash
squeue --long --user=<cnetid>
ssh midway2-xxxx
htop --user=<cnetid>
cd ../output
less pca_regmap.err
less pca_regmap.out
```

Add timing information to the sbatch script using the `time` command,
then re-run the sbatch script.

Once the job has completed, here are some things we can do to assess
resource usage:

```bash
cd ../output
less pca_regmap.err
less pca_regmap.out
sacct --user=<cnetid> --long | less -S
export SACCT_FORMAT=jobid,jobname%12,maxrss,reqmem,start,elapsed,node%12
sacct --user=<cnetid> --units=G | less -S
```

*Exercise:* Based on the output from sacct (and from htop), how much
memory do you think you need to run the R script? Compare against your
earlier estimate.

*Answer:* 10 GB is most likely enough memory.

## Part 2: (Title goes here.)

Develop `pve.regmap.R` code from scratch, while trying out code
interactively in R.

Introduce and inspect the RegMap "phenotype" data, and explain why we
are using this data set (e.g., as opposed to a human data set). Then
explain the task: estimate proportion of variance in each explained by
genetics (genotype). Higher PVE should, roughly, indicate
variables/phenotypes that are more prominent in adaptation. *Caveat:*
I'm applying my reasoning from human & mouse genetics to research on
climate adaptation in plants.

*Mini-exercise:* Interactively explore multithreading of matrix
operations (OpenBLAS) for computing the kinship matrix. What impact
does the number of threads have on compute time and memory? Try first
without requesting multiple CPUs. What happens? Why does the
computation get slower? Use `htop` to examine memory usage and
multithreading (look at CPU% and NLWP columns). How does setting
`export OPENBLAS_NUM_THREADS=2` improve speed of computing the kinship
matrix?

*Exercise 1:* Interactively explore multithreading for computing the
weights. How does increasing the number of threads ("workers") affect
compute time and memory? It is possible that you will have to start a
new sinteractive session with more memory and/or CPUs to experiment
with this fully.

Make some refinements to the script so that we get a nice summary at
the end, and so that it is ready to run non-interactively. Then test
the script with:

```R
rm(list = ls())
source("pve.regmap.R")
```

Alternatively, test the script with `Rscript pve.regmap.R`.

Next, make some additional improvements to the script `pve.regmap.R`
so that the script paramters `phenotype` and `nc` can be specified
from the command line, e.g.:

```bash
Rscript pve.regmap.R aridity_fao 2
```

We now have a non-interactive version of our analysis. Let's use this
to automate the PVE analysis for all 48 phenotypes. Here, we will
develop a new script `pve_regmap.sbatch` from scratch.

## Other notes

+ Reservations: rworkshop1, rworkshop2

+ Etherpads:
  https://etherpad.wikimedia.org/p/rcc-13-nov-2017
  https://etherpad.wikimedia.org/p/rcc-14-nov-2017

+ See here about reasons to use Rscript:
  https://tinyurl.com/y73cnf38
