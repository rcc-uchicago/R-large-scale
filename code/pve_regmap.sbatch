#!/bin/bash

#SBATCH --job-name=pca-regmap
#SBATCH --partition=broadwl
#SBATCH --output=../output/pca_regmap.out
#SBATCH --error=../output/pca_regmap.err
#SBATCH --mem=14G
#SBATCH --time=00:10:00

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Run the R script,
echo "Running pve.regmap.R"
time Rscript pve.regmap.R
