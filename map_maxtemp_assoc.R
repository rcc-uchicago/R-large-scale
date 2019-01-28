# TO DO: Explain here what this script does.

# SET UP ENVIRONMENT
# ------------------
source("functions.R")
library(data.table)

# IMPORT PHENOTYPE DATA
# ---------------------
cat("Reading phenotype data.\n")
pheno <- read.csv("pheno.csv")$bio5_maxT_wm

# IMPORT GENOTYPE DATA
# --------------------
cat("Reading genotype data.\n")
geno <- fread("geno.csv",sep = ",",header = TRUE)
class(geno) <- "data.frame"

# Remove all SNPs that do not vary.
s    <- sapply(geno,sd)
geno <- geno[s > 0]
geno <- geno[1:20000] # *** TEMPORARY ***
p    <- length(geno)

# COMPUTE ASSOCIATIONS
# --------------------
cat(sprintf("Computing association p-values for %d SNPs.\n",p))
timing <- system.time(
  pvalues <- sapply(geno,function (x) get.assoc.pvalue(x,pheno)))
print(timing)

# SUMMARIZE ASSOCIATION RESULTS
# -----------------------------
cat("Distribution of -log10 p-values:\n")
print(quantile(-log10(pvalues),c(0,0.5,0.75,0.9,0.99,0.999)))
