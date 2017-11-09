# Script to compile the RegMap phenotype and genotype data.
#
# Follow these steps to retrieve the RegMap data:
#
# 1. Download the genotype data from
#    bergelson.uchicago.edu/wp-content/uploads/2015/04/call_method_75.tar.gz
#
#   2. tar -zxvf call_method_75.tar.gz
#
#   3. Remove all commas (,) and apostrophes (') from file
#      call_method_75_info.tsv.
#
library(data.table)
library(rsvd)

# Load the sample info.
cat("Reading sample info.\n")
info <- read.table("call_method_75_info.tsv",sep = "\t",header = TRUE,
                   stringsAsFactors = FALSE,quote = "")
info <- info[c("array_id","ecotype_id","median_intensity","latitude",
               "longitude","nativename","firstname","surname","site",
               "region","country")]
rownames(info) <- info$array_id

# Load the genotype data.
cat("Reading genotype data.\n")
geno <- fread("call_method_75_TAIR9.csv",sep = ",",header = TRUE,
              stringsAsFactors = FALSE,verbose = FALSE,
              showProgress = FALSE)
class(geno) <- "data.frame"
geno <- geno[-1,-(1:2)]
geno <- t(geno)

# Convert the genotype data to a binary matrix.
cat("Converting genotype data to a binary matrix.\n")
n   <- nrow(geno)
p   <- ncol(geno)
X   <- matrix(0,n,p)
ids <- rownames(geno)
rownames(X) <- ids
for (i in 1:p) {
  a     <- names(which.min(table(factor(geno[,i]))))
  X[,i] <- geno[,i] == a
}
rm(geno,i,a)

# Compute principal components of genotype matrix using rsvd.
cat("Computing top 20 PCs of genotype matrix.\n")
set.seed(1)
print(system.time(out <- rpca(X,k = 20,center = TRUE,
                              scale = FALSE,retx = TRUE)))

# Save the sample info and PCs to file.
cat("Writing RegMap data to file.\n")
write.csv(cbind(info[ids,],round(out$x,digits = 4)),"regmap.csv",
          quote = FALSE,row.names = FALSE)
