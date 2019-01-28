# TO DO: Explain here what this script does.

# SET UP ENVIRONMENT
# ------------------
library(data.table)

# IMPORT GENOTYPE DATA
# --------------------
cat("Reading genotype data.\n")
geno <- fread("geno.csv",sep = ",",header = TRUE)
geno <- as.matrix(geno)
storage.mode(geno) <- "double"

# COMPUTE KINSHIP MATRIX
# ----------------------
n <- nrow(geno)
cat(sprintf("Computing %d x %d kinship matrix.\n",n,n))
timing <- system.time(K <- tcrossprod(geno))
print(timing)
