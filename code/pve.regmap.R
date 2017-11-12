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
#     --cpus-per-task=9 --mem=36G
#   export OPENBLAS_NUM_THREADS=1
#
# NOTES:
# - For multithreading, add NLWP column to htop.
# - In htop, sort rows by RES column by typing "<" then selecting
#   M_RESIDENT.
# - The multicore variant may fail if you don't request enough memory.
#
# EXERCISE #1: Try different numbers of threads for matrix
# computations. How does it change computation time and memory used?
#
# EXERCISE #2: Try different numbers of threads for mclapply. How does
# it change computation time and memory used?
#

# SET UP ENVIRONMENT
# ------------------
# These are some functions that we will use here and in other parts of
# the workshop.
source("functions.R")

# For running this code with Rscript, I always load the methods
# package just to be safe.
library(methods)

# SCRIPT PARAMETERS
# -----------------
# To run this script using Rscript (or "batch mode"), type the
# following in the command line:
#
#   Rscript eval.geno.impute.R <phenotype> <nc>
#
# where <phenotype> is the phenotype to analyze, and <nc> is the
# number of threads to use for computing the weights.
args <- commandArgs(trailingOnly = TRUE)

# Phenotype to analyze. The default is to analyze the Temperature
# Seasonality phenotype.
if (length(args) < 1) {
  phenotype <- "bio4_temp_season"
} else {
  phenotype <- args[1]
}

# The computation of the sample weights is divided among this many
# threads. The default is to use a single thread.
if (length(args) < 2) {
  nc <- 1
} else {
  nc <- as.integer(args[2])
}

# Candidate values for the PVE parameter.
h <- seq(0.001,0.999,0.001)

# LOAD REGMAP DATA
# ----------------
# NOTES:
# - If you don't request enough memory, the process will be killed
#   after running this command.
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# DATA PROCESSING STEPS
# ---------------------
# NOTES:
#  - Take a few moments to inspect the phenotype data.
#
# Align the phenotype and genotype data.
cat("Processing data.\n")
rows        <- match(rownames(regmap.pheno),regmap.info$ecotype_id)
regmap.geno <- regmap.geno[rows,]

# Get the phenotype data.
y <- regmap.pheno[[phenotype]]

# Center the phenotype data and the columns of the genotype matrix.
y           <- y - mean(y)
regmap.geno <- center.cols(regmap.geno)

# COMPUTE PVE
# -----------
# For each PVE setting h, get the prior variance of the regression
# coefficients assuming a fully "polygenic" model.
cat("Computing prior variance settings.\n")
sa <- get.prior.variances(regmap.geno,h)

# Compute the n x n kinship matrix. This computation may take a minute
# or two.
cat("Computing kinship matrix.\n")
cat("Number of threads used for BLAS operations:",
    Sys.getenv("OPENBLAS_NUM_THREADS"),"\n")
timing.kinship <- system.time(K <- tcrossprod(regmap.geno)/ncol(regmap.geno))
cat("Computation took",timing.kinship["elapsed"],"seconds.\n")

# Now that we have computed the kinship matrix and prior variance
# settings, we no longer need the genotype matrix, so we can remove it
# to free up some memory.
rm(regmap.geno)
gc(verbose = FALSE)

# Now we reach the most numerically intensive part. Here we compute
# the log-weight for each PVE parameter setting.
library(parallel)
cat("Computing weights for",length(h),"settings of PVE parameter.\n")
cat("Weights are being computed separately in",nc,"threads.\n")
cat("Number of threads used for BLAS operations:",
    Sys.getenv("OPENBLAS_NUM_THREADS"),"\n")
timing.weights <-
  system.time(logw <- compute.log.weights.multicore(K,y,sa,nc = nc))
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
# Save the results of the PVE analysis to an .RData file.
cat("Saving results to file.\n")
save(list = c("phenotype","h","h.mean","h.confint","timing.kinship",
              "timing.weights","logw"),
     file = paste("../output/pve.regmap",phenotype,"RData",sep="."))
