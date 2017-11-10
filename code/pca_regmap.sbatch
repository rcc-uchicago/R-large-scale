#!/bin/bash

#SBATCH --job-name=rscript_pca_regmap
#SBATCH --partition=broadwl
#SBATCH --output=../output/pca_regmap.out
#SBATCH --error=../output/pca_regmap.err
#SBATCH --mem=14G
#SBATCH --time=00:10:00

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Run the R script, and time the total execution of the R
# script. While it is running, here are a few of the things you can do
# to monitor progress of the script:
#
#   squeue --long --user=<cnetid>
#   ssh midway2-xxxx
#   htop --user=<cnetid>
#   cd ../output
#   less pca_regmap.err
#   less pca_regmap.out
#
echo "Running pca.regmap.R" 1>&2
time Rscript pca.regmap.R

# Once the job has completed, here are some things you can do:
#
#   cd ../output
#   less pca_regmap.err
#   less pca_regmap.out
#   sacct ...
#
