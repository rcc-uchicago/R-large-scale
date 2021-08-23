# A short script to run a genome-wide association analysis for the
# "maximum temperature of warmest month" climate variable.

# SET UP ENVIRONMENT
# ------------------
library("data.table")

# IMPORT PHENOTYPE DATA
# ---------------------
# Retrieve the  
cat("Reading phenotype data.\n")
pheno <- read.csv("pheno.csv")$bio5_maxT_wm
n     <- length(pheno)
cat(sprintf("Loaded %d temperature measurements.\n",n))

# IMPORT GENOTYPE DATA
# --------------------
cat("Reading genotype data.\n")
geno        <- fread("geno.csv",sep = ",",header = TRUE)
class(geno) <- "data.frame"
n           <- nrow(geno)
p           <- ncol(geno)
cat(sprintf("Loaded %d x %d genotype matrix.\n",n,p))

# Remove all SNPs that do not vary.
cat("Filtering SNPs.\n")
s    <- sapply(geno,sd)
geno <- geno[s > 0]

# COMPUTE ASSOCIATIONS
# --------------------
# Select the first 10,000 SNPs. Comment out this two lines to compute
# associations for all available SNPs.
p    <- 10000
geno <- geno[1:p]

# This function takes two inputs, the genotype (x) and the phenotype
# (y), and returns the p-value indicating the support an association
# between x and y.
get.assoc.pvalue <- function (x, y)
  summary(lm(y ~ x,data.frame(x = x,y = y)))$coefficients["x","Pr(>|t|)"]

# This function will return an association p-value for each column of
# the data frame "dat".
get.assoc.pvalues <- function (dat, y)
  sapply(dat,function (x) get.assoc.pvalue(x,y))

# Compute the association p-values for all SNPs (that is, columns of
# the "geno" data frame).
cat(sprintf("Computing association p-values for %d SNPs.\n",p))
t0 <- proc.time()
pvalues <- get.assoc.pvalues(geno,pheno)
t1 <- proc.time()
print(t1 - t0)

# SUMMARIZE ASSOCIATION RESULTS
# -----------------------------
cat(sprintf("Smallest and largest association p-values across %d SNPs:\n",p))
print(range(pvalues))
