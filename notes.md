# Instructor notes

* Slides:
    - Title (with github repo URL)
    - Aims
	- Outline (divided into X parts)
	- Prerequisities (my expectations)

## Pre-workshop email

+ Prerequisites.
+ Add your name & program to Etherpad.
+ Make sure you can connect to midway2 (ssh or ThinLinc).
+ Make sure you can transfer files (scp or SAMBA).
+ Make sure you are comfortable using a text-based editor such as vim,
  emacs or nano (recommended).
+ We will use R---not RStudio.
+ Mention workshop packet (but do not distribute link).

## Instructor in-class setup

+ Clean up Desktop.
+ Use Terminal, not iTerm.
+ Use a font that better distinguishes commas and periods.
+ Distribute Yubikeys.

## Initial in-class setup

+ Give instructions for Yubikeys (if necessary).
+ WiFi.
+ Etherpad.
+ Connecting to midway2.
+ "history" command.

## Part 1: Analysis of genetic data---interactive and non-interactive

Create two sessions on midway2: one for loading up an R environment,
and a second for developing code (e.g., in emacs).

Create an interactive session for 2 hours on midway2. It is useful to
create a screen session in case you lose your connection at any
point. *Also motivate use of sinteractive by running htop on login
node.*

```bash
screen -S workshop
sinteractive --partition=broadwl --time=2:00:00 --reservation=rworkshop
module load R/3.4.1
R
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

## Other notes

+ See here about reasons to use Rscript:
  https://tinyurl.com/y73cnf38
