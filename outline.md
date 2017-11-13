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
