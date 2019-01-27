# Script to compile the RegMap data. Before running this script,
# download the RegMap genotype data from here:
#
#   bergelson.uchicago.edu/wp-content/uploads/2015/04/call_method_75.tar.gz
#
# The phenotype data are already included in the repository.
library(readr)
source("regmap.functions.R")

# LOAD PHENOTYPE DATA
# -------------------
# This should produce a data frame with 948 rows (samples) and 48
# columns (phenotypes).
cat("Reading phenotype data.\n")
pheno <- read.regmap.pheno("allvars948_notnormd_011311.txt")

# LOAD GENOTYPE DATA
# ------------------
# Load the genotype data and information about the genetic markers.
cat("Reading genotype data.\n")
geno <- read.regmap.geno("call_method_75_TAIR9.csv")

# Convert the genotype data to a binary matrix.
cat("Converting genotype data to a binary matrix.\n")
geno <- regmap.geno.as.binary(geno)

# Align the phenotype and genotype data.
cat("Processing data.\n")
rows <- match(rownames(pheno),rownames(geno))
geno <- geno[rows,]
     
# WRITE DATA TO CSV FILES
# -----------------------
# TO DO.
