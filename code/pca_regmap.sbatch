#!/bin/bash

#SBATCH --job-name=rscript_pca_regmap
#SBATCH --partition=broadwl
#SBATCH --output=output/pca_regmap.out
#SBATCH --error=output/pca_regmap.err
#SBATCH --mem=14G
#SBATCH --time=00:10:00

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Run the R script. While it is running, here are some things you can
# do:
#
#   squeue --user=<cneitid>
#   
#
# Once the job has completed, here are some things you can do:
#
#   <command goes here>
#
Rscript pca.regmap.R


