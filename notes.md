# Instructor notes

## Instructor in-class setup

+ Test reservation.
+ Arrange chairs and tables.
+ Clean up Desktop.
+ Use Terminal, not iTerm.
+ Use Consolata font.
+ Use these Terminal themes: Basic, Novel & Ocean.
+ Fix midway prompt.
+ Distribute Yubikeys.

## Part 2: Implementing multithreaded computation in R for analysis of genetic adaptation to climate

*Exercise 2:* Interactively explore multithreading for computing the
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
develop script `pve_regmap.sbatch`.

## Other notes

+ Reservations used in class: rworkshop1, rworkshop2

+ See here about reasons to use Rscript:
  https://tinyurl.com/y73cnf38
