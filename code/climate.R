# In this script, we will estimate the genetic variance of a selected
# climate variable. This is a numerically intensive operation because
# it involves factorizing a large, symmetric matrix separately for
# each candidate value of the genetic variance. We will explore how
# increasing the number of threads available for the matrix
# computations (BLAS) and for the other numerical computations
# improves the computation time.

# 1. SET UP ENVIRONMENT
# ---------------------
# These are some functions that we will use here and in other parts of
# the workshop.
source("functions.R")

# For running this code with Rscript, I always load the methods
# package just to be safe.
library(methods)

# 2. SCRIPT PARAMETERS
# --------------------
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

# Candidate values for the genetic variance parameter.
h <- seq(0.001,0.999,0.001)

# 3. LOAD REGMAP DATA
# -------------------
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# 4. DATA PROCESSING STEPS
# ------------------------
# Align the phenotype and genotype data.
cat("Processing data.\n")
rows        <- match(rownames(regmap.pheno),regmap.info$ecotype_id)
regmap.geno <- regmap.geno[rows,]

# Get the phenotype data.
y <- regmap.pheno[[phenotype]]

# Center the phenotype data and the columns of the genotype matrix.
y           <- y - mean(y)
regmap.geno <- center.cols(regmap.geno)

# 5. ESTIMATE GENETIC VARIANCE
# ----------------------------
# For each setting h, get the model parameter---the variance of the
# regression coefficients.
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
# to free up some memory. The additional garbage collection step
# ("gc") helps ensure that memory is freed up before the multithreaded
# computation, which may reduce memory requirements.
rm(regmap.geno)
out.gc <- gc(verbose = FALSE)

# Now we reach the most numerically intensive part. Here we compute
# the log-weight for each genetic variance setting.
library(parallel)
cat("Computing weights for",length(h),"settings of genetic variance.\n")
cat("Weights are being computed separately in",nc,"threads.\n")
cat("Number of threads used for BLAS operations:",
    Sys.getenv("OPENBLAS_NUM_THREADS"),"\n")
timing.weights <-
  system.time(logw <- compute.log.weights.mclapply(K,y,sa,nc = nc))
cat("Computation took",timing.weights["elapsed"],"seconds.\n")

# SUMMARIZE RESULTS
# -----------------
# Now that we have done the hard work of computing the importance
# weights, we can quickly compute a numerical estimate of the
# posterior mean h, as well as an estimate of the credible interval
# (more informally, the "confidence interval"). Note that the genetic
# variance estimates are expressed as *proportions*, as in the
# proportion of total variance.
w <- normalizelogweights(logw)
cat("Estimated genetic variance in",phenotype,"(mean and 95% conf. int.):\n")
h.mean    <- sum(w*h)
h.confint <- cred(h,h.mean,w,0.95)
cat(sprintf("%0.3f (%0.3f,%0.3f)\n",sum(w*h),h.confint$a,h.confint$b))

# SAVE RESULTS
# ------------
# Save the results of the genetic variance analysis to an .RData file.
cat("Saving results to file.\n")
save(list = c("phenotype","h","h.mean","h.confint","timing.kinship",
              "timing.weights","logw"),
     file = paste("../output/climate",phenotype,"RData",sep="."))
