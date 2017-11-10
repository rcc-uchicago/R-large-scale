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
# default). Try requesting 14 GB instead:
#
#   sinteractive --partition=broadwl --time=2:00:00 --mem=14G
#
source("functions.R")

# For running this code with Rscript, I always load the methods
# package just to be safe.
library(methods)

# LOAD REGMAP DATA
# ----------------
# NOTES:
# - If you don't request enough memory, the process will be killed
#   after running this command.
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# INSPECT GENOTYPE DATA
# ---------------------
cat("Inspect the genotype data.\n")
ls()
class(regmap.geno)
dim(regmap.geno)
regmap.geno[1:10,1:10]
mode(regmap.geno)
storage.mode(regmap.geno)
format(object.size(regmap.geno),units = "GB")

# COMPUTE PCs
# -----------
# Compute top 2 principal components of genotype matrix using
# randomized PCA.
#
# NOTES:
# - If you don't request enough memory, the process will be killed
#   after running this command.
# - Use htop --user=<cnetid> to profile memory usage (see RES column).
# - First run rpca without profiling compute time.
cat("Computing PCs.\n")
set.seed(1)
library(rsvd)
timing.rpca <-
  system.time(out.rpca <- rpca(regmap.geno,k = 2,center = TRUE,
                               scale = FALSE,retx = TRUE))
cat("Computation took",timing.rpca["elapsed"],"seconds.\n")

# EXAMINE PCA RESULTS
# -------------------
cat("PCA results summary:\n")
print(summary(out.rpca))
cat("Prop. variance explained by PCs 1 and 2:\n")
print(with(out.rpca,eigvals/var))

# Plot the projection of the samples onto the first two PCs. We will
# use ggplot2 to do this.
suppressMessages(library(ggplot2))
suppressMessages(library(cowplot))
pdat <- as.data.frame(out.rpca$x)
p    <- generate.scatterplot(pdat,"PC1","PC2")
ggsave("../output/regmap.pdf",p,width = 7,height = 7)

# Add country information to the plot.
pdat2 <- cbind(pdat,data.frame(country = regmap.info$country))
p2    <- scatterplot.vary.shapeandcolor(pdat2,"PC1","PC2","country")
ggsave("../output/regmap.pdf",p2,width = 7,height = 5.5)

# SAVE RESULTS
# ------------
save(list = c("out.rpca","timing.rpca"),
     file = "../output/pca.regmap.RData")
