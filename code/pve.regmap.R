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

# SCRIPT PARAMETERS
# -----------------
# TO DO.

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

# Choose a phenotype.
phenotype <- "bio4_temp_season"
y         <- regmap.pheno[[phenotype]]

# Center the phenotype data and the columns of the genotype matrix.
y           <- y - mean(y)
regmap.geno <- center.cols(regmap.geno)

# COMPUTE PVE
# -----------
# - Try with different numbers of threads. How does it change time/memory?
# - For multithreading, add NLWP column to htop.
#
# Candidate values for the PVE parameter.
h <- seq(0.001,0.999,0.001)

# For each PVE setting h, get the prior variance of the regression
# coefficients assuming a fully "polygenic" model.
cat("Computing prior variance settings.\n")
sa <- get.prior.variances(regmap.geno,h)

# Compute the n x n kinship matrix. This computation may take a minute
# or two.
cat("Computing kinship matrix.\n")
cat("Number of threads used:",Sys.getenv("OPENBLAS_NUM_THREADS"),"\n")
timing.kinship <- system.time(K <- tcrossprod(regmap.geno)/ncol(regmap.geno))
cat("Computation took",timing.kinship["elapsed"],"seconds.\n")

# Now we reach the numerically intensive part. Here we compute the
# log-weight for each PVE parameter setting.
cat("Computing weights for",length(h),"settings of PVE parameter.\n")
timing.weights <- system.time(logw <- compute.log.weights(K,y,sa))
cat("Computation took",timing.weights["elapsed"],"seconds.\n")

# SUMMARIZE RESULTS
# -----------------
# Now that we have done the hard work of computing the importance
# weights, we can quickly compute a numerical estimate of the
# posterior mean PVE, as well as an estimate of the credible interval
# (more informally, the "confidence interval").
w <- normalizelogweights(logw)
cat("Proportion of variance in",phenotype,"explained by available\n")
cat("genotypes (mean and 95% conf. int.):\n")
h.mean    <- sum(w*h)
h.confint <- cred(h,h.mean,w,0.95)
  cat(sprintf("%0.3f (%0.3f,%0.3f)\n",sum(w*h),h.confint$a,h.confint$b))

# SAVE RESULTS
# ------------
# TO DO.
