# Short script to compute and summarize the distribution of SNP minor
# allele frequencies from the RegMap genotype data.

# SET UP ENVIRONMENT
# ------------------
library("data.table")

# IMPORT GENOTYPE DATA
# --------------------
cat("Reading genotype data.\n")
geno <- fread("geno.csv",sep = ",",header = TRUE)
class(geno) <- "data.frame"
n <- nrow(geno)
p <- ncol(geno)
cat(sprintf("Loaded %d x %d genotype matrix.\n",n,p))

# COMPUTE MAFs
# ------------
cat(sprintf("Computing MAFs for %d SNPs.\n",p))
maf <- sapply(geno,mean)
maf <- pmin(maf,1 - maf)

# SUMMARIZE RESULTS
# -----------------
cat(sprintf("Distribution of MAFs across %d SNPs:\n",p))
print(summary(maf))
