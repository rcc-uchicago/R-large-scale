# You will find that you need more than 2 GB of memory (this is the
# default). Try requesting 14 GB instead:
#
#   sinteractive --partition=broadwl --time=2:00:00 --mem=14G
#

# SET UP ENVIRONMENT
# ------------------
# These are some functions that we will use here and in other parts of
# the workshop.
source("functions.R")

# For running this code with Rscript, I always load the methods
# package just to be safe.
library(methods)

# Set the sequence of pseudorandom numbers (useful for making sure
# that the randomized PCA results are reproducible).
set.seed(1)

# LOAD REGMAP DATA
# ----------------
# NOTES:
#
#  - Introduce RegMap A. thaliana data set. (Good opportunity for
#    interaction.)
#
#  - If you don't request enough memory, the process will be killed
#    after running the load command.
#
cat("Loading RegMap data.\n")
load("../data/regmap.RData")

# INSPECT GENOTYPE DATA
# ---------------------
# A few useful commands for inspecting the data we just loaded:
#
#   ls()
#   class(regmap.geno)
#   dim(regmap.geno)
#   regmap.geno[1:10,1:10]
#   mode(regmap.geno)
#   storage.mode(regmap.geno)
#   format(object.size(regmap.geno),units = "GB")
#

# COMPUTE PCs
# -----------
# Compute top 2 principal components of genotype matrix using
# randomized PCA.
#
# NOTES:
#
# - If you don't request enough memory, the process will be killed
#   after running this command.
#
# - First, run rpca without profiling compute time. Then add the
#   system.time call.
#
# - While rpca is running, use htop --user=<cnetid> to profile memory
#   usage (see RES column, and sort by this column by typing
#   "M". Another useful keystroke in htop: "p".
#
# EXERCISE: Determine amount of memory needed to compute PCs. Use
# Etherpad to share results.
#
cat("Computing PCs.\n")
library(rsvd)
timing.rpca <-
  system.time(out.rpca <- rpca(regmap.geno,k = 2,center = TRUE,
                               scale = FALSE,retx = TRUE))
cat("Computation took",timing.rpca["elapsed"],"seconds.\n")

# EXAMINE PCA RESULTS
# -------------------
# NOTES:
#
#  - Explain (very briefly) why we use ggplot2.
#
#  - Interpret and discuss results.
#
#  - Demonstrate transfering files to view PDFs locally (alternative,
#    of course, is to use ThinLinc).
#
cat("PCA results summary:\n")
print(summary(out.rpca))
cat("Prop. variance explained by PCs 1 and 2:\n")
print(with(out.rpca,eigvals/var))

# Plot the projection of the samples onto the first 2 PCs. We will
# use ggplot2 to do this.
cat("Generating PCA plots.\n")
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
# Save the results of the PCA analysis to an .RData file.
cat("Saving PCA results to file.\n")
save(list = c("out.rpca","timing.rpca"),
     file = "../output/pca.regmap.RData")
