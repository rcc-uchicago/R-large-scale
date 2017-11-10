#!/bin/bash

#SBATCH --job-name=simpleML
#SBATCH --partition=broadwl
#SBATCH --output=pca_regmap.out
#SBATCH --error=pca_regmap.err

# For reproducibility, add version number.
module load R/3.4.1

Rscript 
