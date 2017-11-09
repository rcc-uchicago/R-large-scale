# Outline

1. Setup:
   (a) WiFi
   (b) Connect to midway2

2. PCA of RegMap data using prcomp:

   (a) Write R script, and run interactively.
   (b) Add CPU time profiling.
   (c) Run R script using Rscript.
   (d) Write sbatch script to.
   (e) Submit one SLURM job using sbatch.
   (f) Profile CPU time using command-line program.
   (g) Submit sbatch jobs using different numbers of SNPs.
   (h) Monitor jobs (squeue, htop) and get computation stats (sacct).

3. Complexity analysis of prcomp:

   (a) Write R script to submit multiple SLURM jobs.
   (b) Write R Script to compile results from multiple runs.
   (c) EXERCISE 1: Run PCA analyses, compile results, plot results,
       interpret results, and share conclusions on Etherpad
   (d) Discuss results of first exercise.

4. PCA of RegMap data using rpca.
   (a) Write R script.
   (b) Compare runtime against 
