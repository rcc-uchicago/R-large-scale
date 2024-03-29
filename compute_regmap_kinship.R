# Short script to compute the 948 x 948 covariance ("kinship") matrix
# from the RegMap genotype data.

# SET UP ENVIRONMENT
# ------------------
library("data.table")

# IMPORT GENOTYPE DATA
# --------------------
# Here the genotype data are loaded as a matrix of floating-point numbers.
cat("Reading genotype data.\n")
geno <- fread("geno.csv",sep = ",",header = TRUE)
geno <- as.matrix(geno)
storage.mode(geno) <- "double"

# COMPUTE KINSHIP MATRIX
# ----------------------
# The kinship matrix is computed by taking the cross-product of the
# genotype matrix.
n <- nrow(geno)
cat(sprintf("Computing %d x %d kinship matrix.\n",n,n))
t0 <- proc.time()
K  <- tcrossprod(geno)
t1 <- proc.time()
print(t1 - t0)
