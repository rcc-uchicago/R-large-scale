#!/bin/bash

# IMPORTANT NOTE: The amount of requested time and memory needs to be
# adjusted for the R script to be complete successfully.

#SBATCH --job-name=pca
#SBATCH --partition=broadwl
#SBATCH --reservation=rworkshop2
#SBATCH --output=../output/pca_out.txt
#SBATCH --error=../output/pca_err.txt
#SBATCH --mem=2G
#SBATCH --time=00:01:00

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Run the R script.
Rscript pca.R
