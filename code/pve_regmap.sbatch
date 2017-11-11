#!/bin/bash

#SBATCH --job-name=pve-regmap
#SBATCH --partition=broadwl
#SBATCH --output=../output/pve_regmap.out
#SBATCH --error=../output/pve_regmap.err
#SBATCH --mem=24G
#SBATCH --time=00:10:00

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Set the number of threads used for matrix operations.
export OPENBLAS_NUM_THREADS=2

# Run the R script, saving the results to an .RData file.
echo "Running pve.regmap.R"
Rscript pve.regmap.R aridity_fao 4
