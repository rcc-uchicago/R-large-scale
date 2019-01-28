#!/bin/bash

#SBATCH --partition=broadwl
#SBATCH --reservation=workshop
#SBATCH --time=00:10:00
#SBATCH --mem=1G

# Get the input data file as specified by the command-line argument.
INPUT=${1}

# For reproducibility, add version numbers to the "module load" calls.
module load R/3.5.1

# Run the R script.
echo "Running summarize_mafs.R ${INPUT}"
Rscript summarize_mafs.R ${INPUT} > summarize_mafs.out

