# Script to compile the RegMap data. Before running this script,
# download the RegMap genotype data from here:
# bergelson.uchicago.edu/wp-content/uploads/2015/04/call_method_75.tar.gz
# The phenotype data are already included in the repository.
library(readr)
source("regmap.functions.R")

# LOAD & PREPARE PHENOTYPE DATA
# -----------------------------
# This should produce a data frame with 948 rows (samples) and 48
# columns (phenotypes).
pheno <- read.regmap.pheno("allvars948_notnormd_011311.txt")

# LOAD & PREPARE GENOTYPE DATA
# ----------------------------
# Load the genotype data and information about the genetic markers.
geno <- read.regmap.geno("call_method_75_TAIR9.csv")

# Convert the genotype data to a binary matrix.
geno <- regmap.geno.as.binary(geno)

# Align the phenotype and genotype data.
rows <- match(rownames(pheno),rownames(geno))
geno <- geno[rows,]
     
# WRITE DATA TO CSV FILES
# -----------------------
geno <- as.data.frame(geno)
write.csv(pheno,"pheno.csv",quote = FALSE,row.names = FALSE)
write.csv(geno,"geno.csv",quote = FALSE,row.names = FALSE)
