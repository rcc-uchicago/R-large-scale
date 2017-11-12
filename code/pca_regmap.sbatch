#!/bin/bash

#SBATCH --job-name=pca-rm
#SBATCH --partition=broadwl
#SBATCH --reservation=rworkshop
#SBATCH --output=../output/pca_regmap.out
#SBATCH --error=../output/pca_regmap.err
#SBATCH --mem=14G
#SBATCH --time=00:10:00

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Run the R script, and time the total execution of the R
# script.
echo "Running pca.regmap.R" 1>&2
time Rscript pca.regmap.R
