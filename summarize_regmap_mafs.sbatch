#!/bin/bash

#SBATCH --partition=broadwl
#SBATCH --reservation=rworkshop
#SBATCH --time=00:10:00
#SBATCH --mem=1G

# For reproducibility, add version numbers to the "module load" calls.
module load R/4.1.0

# Run the R script.
echo "Running summarize_regmap_mafs.R"
Rscript summarize_regmap_mafs.R > regmap_mafs.out
