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
print(ls())
print(class(regmap.geno))
print(dim(regmap.geno))
print(regmap.geno[1:10,1:10])
print(mode(regmap.geno))
print(storage.mode(regmap.geno))
print(object.size(regmap.geno),units = "GB")

# COMPUTE PCs
# -----------
# Compute top 2 principal components of genotype matrix using
# randomized PCA.
#
# NOTES:
# - Use htop --user=<cnetid> to profile memory usage (see RES column).
# - First run rpca without profiling compute time.
# - Try with k=20 and k=100. Does it take more time/memory?
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
library(ggplot2)
library(cowplot)
pdat <- as.data.frame(out.rpca$x)
p    <- ggplot(data = pdat,mapping = aes(x = PC1,y = PC2)) +
          geom_point(shape = 20,size = 3,color = "black")
ggsave("regmap.pdf",p)

# Add country information to the plot.
pdat2  <- cbind(pdat,data.frame(country = regmap.info$country))
colors <- rep(c("#E69F00","#56B4E9","#009E73","#F0E442","#0072B2",
                "#D55E00","#CC79A7"),times = 5)
shapes <- rep(c(19,17,8,1,3),each = 7)
p2     <- ggplot(data = pdat2,
                 mapping = aes(x = PC1,y = PC2,color = country,
                               shape = country)) +
           geom_point(size = 3) +
           scale_color_manual(values = colors) +
           scale_shape_manual(values = shapes)
ggsave("regmap.pdf",p2,width = 7,height = 5.5)
