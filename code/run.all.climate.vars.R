# This script runs the genetic variance analysis for all climate
# variables in the RegMap data set.
library(methods)

# LOAD REGMAP DATA
# ----------------
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# RUN ANALYSES FOR ALL CLIMATE VARIABLES
# --------------------------------------
phenotypes <- names(regmap.pheno)
cat("Submitting SLURM jobs for analysis of RegMap climate variables:\n")
for (phenotype in c("bio1_meant","bio2_diur_rng","bio3_isotherm")) {
  cat(" - ",phenotype,": ",sep="")
  system(sprintf(paste("sbatch --job-name=%s",
                       "--output=../output/climate_%s.out",
                       "--error=../output/climate_%s.err",
                       "climate.sbatch %s"),
                 phenotype,phenotype,phenotype,phenotype))
}
