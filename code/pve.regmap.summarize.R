# This script summarizes the PVE analyses of all the phenotypes in the
# RegMap data set.

# LOAD REGMAP DATA
# ----------------
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# LOAD PVE ESTIMATES FOR ALL PHENOTYPES
# -----------------------------------
cat("Compiling results of PVE analyses.\n")
phenotypes      <- names(regmap.pheno)
n               <- length(phenotypes)
h.est           <- matrix(0,n,3)
rownames(h.est) <- phenotypes
colnames(h.est) <- c("low","mean","high")
for (phenotype in phenotypes) {
  load(sprintf("../output/pve.regmap.%s.RData",phenotype))
  h.est[phenotype,] <- c(h.confint$a,h.mean,h.confint$b)
}

# SUMMARIZE PVE RESULTS
# ---------------------
cat("Summary of PVE estimates:\n")
print(summary(h.est))
