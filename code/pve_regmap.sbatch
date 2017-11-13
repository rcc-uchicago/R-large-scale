#!/bin/bash

# This bash script illustrates how to use the sbatch command in SLURM
# to submit a job to the broadwl partition, in which some of the
# script parameters are specified in the command line.
#
# Here is an example of running this script using SLURM from the
# shell:
#
#   sbatch --job-name=pve --output=pve_regmap.out \
#     --error=pve_regmap.err pve_regmap.sbatch aridity_fao
#

#SBATCH --partition=broadwl
#SBATCH --reservation=rworkshoptest
#SBATCH --mem=12G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:10:00

# Get the phenotype specified as a command-line argument.
PHENOTYPE=${1}

# Specify the number of threads to use for the mclapply call.
NC=4

# For reproducibility, add version number to "module load" call.
module load R/3.4.1

# Set the number of threads used for matrix operations.
export OPENBLAS_NUM_THREADS=2

# Run the R script, saving the results to an .RData file.
echo "Running pve.regmap.R"
Rscript pve.regmap.R ${PHENOTYPE} ${NC}
