# Short script to center and scale the columns (i.e., SNPs) of a
# matrix containing genotypes.

# SET UP ENVIRONMENT
# ------------------
library(data.table)

# IMPORT GENOTYPE DATA
# --------------------
# Load the genotype data as a matrix of floating-point numbers.
cat("Reading genotype data.\n")
geno <- fread("geno.csv",sep = ",",header = TRUE)
geno <- as.matrix(geno)
storage.mode(geno) <- "double"

# CENTER & SCALE GENOTYPE MATRIX
# ------------------------------
# After this step, each column of the genotype matrix should have a
# mean of zero and a standard deviation of 1.
cat("Centering and scaling genotype matrix.\n")
timing <- system.time(geno <- scale(geno))
print(timing)
