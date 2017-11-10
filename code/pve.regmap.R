# TO DO: Add description and notes here.
#
# For the multithreaded matrix computations:
#
#   sinteractive --partition=broadwl --time=2:00:00 \
#     --cpus-per-task=8 --mem=8G
#   export OPENBLAS_NUM_THREADS=8
#

# LOAD REGMAP DATA
# ----------------
# NOTES:
# - If you don't request enough memory, the process will be killed
#   after running this command.
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# - Try with different numbers of threads. How does it change time/memory?
# - For multithreading, add NLWP column to htop.

# TO DO: Explain here what this does.
library(Matrix)
cat("Number of threads:",Sys.getenv("OPENBLAS_NUM_THREADS"),"\n")
rows <- match(rownames(regmap.pheno),regmap.info$ecotype_id)
X    <- regmap.geno[rows,]
Y    <- as.matrix(regmap.pheno)
timing <- system.time({
  K    <- tcrossprod(X)
  r    <- solve(K,Y)
})
cat("Computation took",timing["elapsed"],"seconds.\n")

