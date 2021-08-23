#!/bin/bash

#SBATCH --partition=broadwl
#SBATCH --reservation=rworkshop_test
#SBATCH --time=00:10:00
#SBATCH --mem=4G

# Get the input data file as specified by the command-line argument.
INPUT=${1}

# For reproducibility, add version numbers to the "module load" calls.
module load R/4.1.0

# Run the R script.
echo "Running summarize_mafs.R ${INPUT}"
Rscript summarize_mafs.R ${INPUT} > summarize_mafs.Rout
