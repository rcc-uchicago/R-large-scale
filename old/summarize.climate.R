# This script summarizes the genetic variance analyses of all the
# RegMap climate variables.
library(methods)

# LOAD REGMAP DATA
# ----------------
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# LOAD RESULTS FOR ALL PHENOTYPES
# -------------------------------
cat("Compiling results.\n")
phenotypes      <- names(regmap.pheno)
n               <- length(phenotypes)
h.est           <- matrix(0,n,3)
rownames(h.est) <- phenotypes
colnames(h.est) <- c("low","mean","high")
for (phenotype in phenotypes) {
  load(sprintf("../output/climate.%s.RData",phenotype))
  h.est[phenotype,] <- c(h.confint$a,h.mean,h.confint$b)
}

# SUMMARIZE RESULTS
# -----------------
cat("Summary of genetic variance estimates:\n")
print(h.est)
