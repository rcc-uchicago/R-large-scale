# This script runs the PVE analysis for all phenotypes in the RegMap
# data set.
library(methods)

# LOAD REGMAP DATA
# ----------------
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# ESTIMATE PVE IN ALL PHENOTYPES
# ------------------------------
phenotypes <- names(regmap.pheno)
cat("Submitting SLURM jobs for PVE analyses in RegMap data:\n")
for (phenotype in phenotypes) {
  cat(" - ",phenotype,": ",sep="")
  system(sprintf(paste("sbatch --job-name=%s",
                       "--output=../output/pve_regmap_%s.out",
                       "--error=../output/pve_regmap_%s.err",
                       "pve_regmap.sbatch %s 1"),
                 phenotype,phenotype,phenotype,phenotype))
}
