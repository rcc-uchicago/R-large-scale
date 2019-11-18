# Short script to compute and summarize the distribution of SNP minor
# allele frequencies from genotype data stored in a CSV file.
#
# This script assumes the genotypes are encoded as allele accounts,
# and the sample are haploid individuals, so that all genotypes are
# binary numbers (0 or 1).

# PROCESS COMMAND-LINE ARGUMENTS
# ------------------------------
args      <- commandArgs(trailingOnly = TRUE)
geno.file <- args[1]

# SET UP ENVIRONMENT
# ------------------
library(data.table)

# IMPORT GENOTYPE DATA
# --------------------
cat(sprintf("Reading genotype data from %s.\n",geno.file))
geno        <- fread(geno.file,sep = ",",header = TRUE)
class(geno) <- "data.frame"
n           <- nrow(geno)
p           <- ncol(geno)
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
