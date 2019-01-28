# TO DO: Explain here what this script does.

# SET UP ENVIRONMENT
# ------------------
library(data.table)

# IMPORT PHENOTYPE DATA
# ---------------------
cat("Reading phenotype data.\n")
pheno <- read.csv("pheno.csv")$bio5_maxT_wm

# IMPORT GENOTYPE DATA
# --------------------
cat("Reading genotype data.\n")
geno        <- fread("geno.csv",sep = ",",header = TRUE)
class(geno) <- "data.frame"
p           <- ncol(geno)

# COMPUTE ASSOCIATIONS
# --------------------
cat(sprintf("Computing association p-values for %d SNPs.\n",p))
for (i in 1:p) {

}
  
