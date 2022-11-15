#!/bin/bash

#SBATCH --partition=caslake
#SBATCH --reservation=r_workshop
#SBATCH --time=00:10:00
#SBATCH --mem=1G

# For reproducibility, add version numbers to the "module load" calls.
module load R/4.2.0

# Run the R script.
echo "Running summarize_regmap_mafs.R"
Rscript summarize_regmap_mafs.R > regmap_mafs.Rout
