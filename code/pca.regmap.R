# TO DO: Add description and notes here.
#
# Start by requesting an interactive session for 2 hours on midway2
# ("Broadwell"). It is useful to create a screen session in case you
# lose your connection at any point.
#
#   screen -S rcc_workshop
#   sinteractive --partition=broadwl --time=2:00:00
#   module load R/3.4.1
#   R
#
# You will find that you need more than 2 GB of memory (this is the
# default). Try requesting 4 GB instead:
#
#   sinteractive --partition=broadwl --time=2:00:00 --mem=6G
#

# LOAD GENOTYPE DATA
# ------------------
# NOTES:
# - If you don't request enough memory, the process will be killed
#   after running this command.
load("../data/regmap.RData")

# INSPECT GENOTYPE DATA
# ---------------------
ls()
class(regmap.geno)
dim(regmap.geno)
regmap.geno[1:10,1:10]
mode(regmap.geno)
storage.mode(regmap.geno)
print(object.size(regmap.geno),units = "GB")

# COMPUTE PCs
# -----------
# Compute top 2 principal components of genotype matrix using
# randomized PCA.
cat("Compute first PCs of genotype matrix.\n")
set.seed(1)
library(rsvd)
out.rpca <- rpca(regmap.geno,k = 2,center = TRUE,scale = FALSE,retx = TRUE)
