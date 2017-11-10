# In this script, we will compute a numerical estimate of the
# proportion of variance in the quantitative trait explained by the
# available genotypes (abbreviated as "PVE"). This is a numerically
# intensive operation because it involves factorizing a large,
# symmetric matrix separately for each candidate value of the PVE. We
# will explore how increasing the number of threads available for the
# matrix computations (BLAS) and for the other numerical computations
# improves the computation time.
#
# For the multithreaded matrix computations:
#
#   sinteractive --partition=broadwl --time=2:00:00 \
#     --cpus-per-task=8 --mem=8G
#   export OPENBLAS_NUM_THREADS=8
#
source("functions.R")

# LOAD REGMAP DATA
# ----------------
# NOTES:
# - If you don't request enough memory, the process will be killed
#   after running this command.
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# DATA PROCESSING STEPS
# ---------------------
# Align the phenotype and genotype data.
cat("Processing data.\n")
rows        <- match(rownames(regmap.pheno),regmap.info$ecotype_id)
regmap.geno <- regmap.geno[rows,]

y <- regmap.pheno["bio4_temp_season"]

# Center the phenotypes and the columns of the genotype matrix.
center.cols(regmap.geno)

n <- nrow(X)
p <- ncol(X)
X <- X - rep.row(colMeans(regmap.geno),nrow(regmap.geno))
y <- y - mean(y)
```




# COMPUTE PVE
# -----------
# - Try with different numbers of threads. How does it change time/memory?
# - For multithreading, add NLWP column to htop.
#
# Candidate values for the PVE parameter.
h <- seq(0.01,0.99,0.01)

# For each PVE setting h, get the prior variance of the regression
# coefficients assuming a fully "polygenic" model.
cat("Compute prior variance settings.\n")
sa <- get.prior.variances(regmap.geno,h)

# Compute the n x n kinship matrix. This computation may take a minute
# or two.
cat("Computing kinship matrix.\n")
K <- tcrossprod(regmap.geno)/ncol(regmap.geno)

# Now we reach the numerically intensive part. Here we compute the
# log-weight for each PVE parameter setting.
cat("Computing weights for",length(h),"settings of PVE parameter.\n")
timing <- system.time(logw <- compute.log.weights(K,y,sa))
cat("Computation took",timing["elapsed"],"seconds.\n")

stop()

# TO DO: Explain here what this does.
library(Matrix)
cat("Number of threads:",Sys.getenv("OPENBLAS_NUM_THREADS"),"\n")
timing <- system.time({
  K    <- tcrossprod(X)
  r    <- solve(K,Y)
})

