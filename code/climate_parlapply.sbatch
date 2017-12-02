#!/bin/bash

# This bash script illustrates how to use the sbatch command in SLURM
# to submit a job to the broadwl partition, in which one of the
# script parameters is specified in the command line. Here is an
# example of running this script using SLURM from the shell:
# 
#   sbatch --job-name=climate --output=climate_out.txt \
#     --error=climate_err.txt climate_parlapply.sbatch aridity_fao
#

#SBATCH --partition=broadwl
#SBATCH --mem=6G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:10:00

# Get the phenotype specified as a command-line argument.
PHENOTYPE=${1}

# Specify the number of threads to use for the mclapply call.
NC=8

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Set the number of threads used for matrix operations.
export OPENBLAS_NUM_THREADS=1

# Run the R script, saving the results to an .RData file.
echo "Running climate.R"
Rscript climate.R ${PHENOTYPE} ${NC} parlapply
