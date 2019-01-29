# Short script to center and scale the columns (i.e., SNPs) of a
# matrix containing genotypes.

# SET UP ENVIRONMENT
# ------------------
library(data.table)
library(matrixStats)
library(Rcpp)

# IMPORT GENOTYPE DATA
# --------------------
# Load the genotype data as a matrix of floating-point numbers.
cat("Reading genotype data.\n")
geno <- fread("geno.csv",sep = ",",header = TRUE)
geno <- as.matrix(geno)
storage.mode(geno) <- "double"

# Remove all SNPs that do not vary.
cat("Filtering SNPs.\n")
s    <- colSds(geno)
geno <- geno[,s > 0]

# CENTER & SCALE GENOTYPE MATRIX
# ------------------------------
# After this step, each column of the genotype matrix should have a
# mean of zero and a standard deviation of 1.
cat("Centering and scaling genotype matrix.\n")
sourceCpp("scale.cpp")
timing <- system.time({
  geno.scaled <- geno
  mu <- colMeans(geno)
  s  <- colSds(geno)
  scale_rcpp(geno.scaled,mu,s)
})
print(timing)

# VERIFY CENTERING & SCALING
# --------------------------
cat("Get the largest & smallest column mean:\n")
print(range(colMeans(geno.scaled)))
cat("Get the largest & smallest column s.d.:\n")
print(range(colSds(geno.scaled)))
