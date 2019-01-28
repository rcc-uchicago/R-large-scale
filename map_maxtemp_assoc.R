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
geno <- fread("geno.csv",sep = ",",header = TRUE)
class(geno) <- "data.frame"

# Remove all SNPs that do not vary.
s    <- sapply(geno,sd)
geno <- geno[s > 0]
p    <- length(geno)

# COMPUTE ASSOCIATIONS
# --------------------
# Define a function to...
get.assoc.pvalue <- function (x, y)
  summary(lm(y ~ x,data.frame(x = x,y = y)))$coefficients["x","Pr(>|t|)"]
get.assoc.pvalues <- function (X, y)
  sapply(X,function (x) get.assoc.pvalue(x,y))

# TO DO: Explain here what this code chunk does.
#
# TO DO: Give (roughly) how long this computation takes on midway2.
cat(sprintf("Computing association p-values for %d SNPs.\n",p))
timing <- system.time(pvalues <- get.assoc.pvalues(geno,pheno))
print(timing)

library(parallel)
nc <- 8
cl <- makeCluster(nc)
clusterExport(cl,c("get.assoc.pvalue","get.assoc.pvalues"))
cols <- clusterSplit(cl,1:p)
timing <- system.time(
  out <- parLapply(cl,cols,
    function (i, geno, pheno) get.assoc.pvalues(geno[,i],pheno),
    geno, pheno))
pvalues <- rep(0,p)
pvalues[unlist(cols)] <- unlist(out)
stopCluster(cl)

# SUMMARIZE ASSOCIATION RESULTS
# -----------------------------
cat("Distribution of p-values:\n")
print(quantile(pvalues,c(0,0.001,0.01,0.1,0.25,0.5,1)))
