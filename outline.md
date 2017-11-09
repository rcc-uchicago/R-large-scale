# Outline

1. Setup:

   (a) WiFi.
   (b) Connect to midway2 (ssh or ThinLinc).
   (c) Clone or download lessons materials.

2. PCA of RegMap data using prcomp.

   (a) Write R script, and run interactively.
   (b) Inspect data set.
   (b) Add CPU time profiling.
   (c) Run R script using Rscript.
   (d) Write sbatch script to.
   (e) Submit one SLURM job using sbatch.
   (f) Profile CPU time using command-line program.
   (g) Submit sbatch jobs using different numbers of SNPs.
   (h) Monitor jobs (squeue, htop) and get computation stats (sacct).

3. Complexity analysis of prcomp.

   (a) Write R script to submit multiple SLURM jobs.
   (b) Write R Script to compile results from multiple runs.
   (c) EXERCISE 1: Run PCA analyses, compile results, plot results,
       interpret results, and share conclusions on Etherpad.
   (d) Discuss results of first exercise.

4. Read RegMap data quickly from CSV file using data.table::fread.

   (a) Inspect CSV file.
   (b) Compare runtime of read.csv and fread.

5. PCA of RegMap data using rpca.

   (a) Write R script.
   (b) Compare prcomp and rpca runtime.
   (c) Compare prcomp and rpca output.

6. Profile memory used in PCA analysis.

   (a) Write R script for rpca with n SNPs.
   (b) Run script with a large number of SNPs.
   (c) Inspect memory used using htop.
   (d) Inspect memory used using sacct.
   (e) EXERCISE 2: Run rpca with different numbers of SNPs, and look at
       trend in the memory used ("space complexity"), and share
	   conclusions on Etherpad.
   (f) Discuss results of second exercise.

7. Multithreaded matrix computation.

   (a) Run rpca interactively.
   (b) Inspect CPUs used using htop.
   (c) Write sbatch script for multithreaded computation.
   (d) EXERCISE 3: Run rpca with different numbers of threads, 
       understand computation time vs. number of threads,
	   and share conclusions on Etherpad.
   (e) Discuss results of third exercise.

9. Parallelizing computation using mclapply:
   Compute minor allele frequencies

8. Speeding up repeated operations using Rcpp.
   Compute minor allele frequencies

