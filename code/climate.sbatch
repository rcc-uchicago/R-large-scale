#!/bin/bash

# This bash script illustrates how to use the sbatch command in SLURM
# to submit a job to the broadwl partition, in which some of the
# script parameters are specified in the command line.
#
# Here is an example of running this script using SLURM from the
# shell:
#
#   sbatch --job-name=climate --output=climate_out.txt \
#     --error=climate_err.txt climate.sbatch aridity_fao
#
# IMPORTANT NOTE: You will need to adjust the amount of memory, the
# number of CPUs, the requested compute time, and the number of
# threads for the mclapply call.
# 
#SBATCH --partition=broadwl
#SBATCH --reservation=rworkshop2
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:01:00

# Get the phenotype specified as a command-line argument.
PHENOTYPE=${1}

# Specify the number of threads to use for the mclapply call.
NC=1

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Set the number of threads used for matrix operations.
export OPENBLAS_NUM_THREADS=1

# Run the R script, saving the results to an .RData file.
echo "Running climate.R"
Rscript climate.R ${PHENOTYPE} ${NC}

