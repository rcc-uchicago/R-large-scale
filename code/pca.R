# Script to compute and visualize the top principal components (PCs)
# in the RegMap data. 

# 1. SET UP ENVIRONMENT
# ---------------------
# These are some functions that we will use here and in other parts of
# the workshop.
source("functions.R")

# For running this code with Rscript, I always load the methods
# package just to be safe.
library(methods)

# Set the sequence of pseudorandom numbers (useful for making sure
# that the randomized PCA results are reproducible).
set.seed(1)

# 2. LOAD REGMAP DATA
# -------------------
cat("Loading RegMap data.\n")
load("../data/regmap.RData")
cat("Number of samples:",ncol(regmap.geno),"\n")
cat("Number of genetic markers:",nrow(regmap.geno),"\n")

# 3. COMPUTE PCs
# --------------
# This is where most of the computation happens: here we compute the
# top 2 principal components of genotype matrix using randomized PCA
# ("rpca"). I've added a system.time call to record the PCA
# computation time.
cat("Computing PCs.\n")
library(rsvd)
timing.rpca <-
  system.time(out.rpca <- rpca(regmap.geno,k = 2,center = TRUE,
                               scale = FALSE,retx = TRUE))
cat("Computation took",timing.rpca["elapsed"],"seconds.\n")

# 4. EXAMINE PCA RESULTS
# ----------------------
cat("PCA results summary:\n")
print(summary(out.rpca))

# Plot the projection of the samples onto the first 2 PCs, and add
# country information to the plot. We will use ggplot2 to do this.
cat("Generating PCA plots.\n")
suppressMessages(library(ggplot2))
suppressMessages(library(cowplot))
pdat <- cbind(out.rpca$x,data.frame(country = regmap.info$country))
p    <- scatterplot.vary.shapeandcolor(pdat,"PC1","PC2","country")
ggsave("../output/regmap.pdf",p,width = 7,height = 5.5)

# 5. SAVE RESULTS
# ---------------
# Save the results of the PCA analysis to an .RData file.
cat("Saving PCA results to file.\n")
save(list = c("out.rpca","timing.rpca"),
     file = "../output/pca.regmap.RData")
