#!/bin/bash

#SBATCH --partition=broadwl
#SBATCH --reservation=workshoptest
#SBATCH --time=00:10:00

# For reproducibility, add version numbers to the "module load" calls.
module load R/3.5.1

# Run the R script.
echo "Running summarize_regmap_mafs.R"
Rscript summarize_regmap_mafs.R > summarize_regmap_mafs.out
