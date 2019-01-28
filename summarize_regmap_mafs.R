# TO DO: Explain here briefly what this script does.

# SET UP ENVIRONMENT
# ------------------
library(data.table)

# IMPORT GENOTYPE DATA
# --------------------
cat("Reading genotype data.\n")
geno <- fread("geno.csv",sep = ",",header = TRUE)
class(geno) <- "data.frame"

# COMPUTE MAFs
# ------------
cat("Computing minor allele frequencies.\n")
maf <- sapply(geno,mean)
maf <- pmin(maf,1 - maf)

# SUMMARIZE RESULTS
# -----------------
print(summary(maf))

# SESSION INFO
# ------------
print(sessionInfo())
