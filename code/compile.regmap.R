# Script to compile the RegMap data.
#
# Before running this script, download the RegMap data from 
# bergelson.uchicago.edu/wp-content/uploads/2015/04/call_method_75.tar.gz
# and extract the file call_method_75_TAIR9.csv into the "data" directory.
#
library(data.table)

# LOAD SAMPLE INFO
# ----------------
cat("Reading sample info.\n")
regmap.info <- read.table("../data/call_method_75_info.tsv",sep = "\t",
                      header = TRUE,as.is = c("nativename","region"),
                      quote = "",encoding="UTF-8")
ids         <- regmap.info$array_id
regmap.info <- regmap.info[c("ecotype_id","median_intensity","latitude",
                             "longitude","region","country")]
rownames(regmap.info) <- ids

# If the region is the empty string, set it to missing. Then set this
# column to a factor.
rows                       <- which(regmap.info$region == "")
regmap.info[rows,"region"] <- NA
regmap.info                <- transform(regmap.info,region = factor(region))

# LOAD GENOTYPE DATA
# ------------------
# Load the genotype data and information about the genetic markers.
cat("Reading genotype data.\n")
out <- fread("../data/call_method_75_TAIR9.csv",sep = ",",header = TRUE,
             stringsAsFactors = FALSE,verbose = FALSE,
             showProgress = FALSE)
class(out)     <- "data.frame"
out            <- out[-1,]
regmap.markers <- out[,1:2]
names(regmap.markers) <- c("chr","pos")
regmap.markers <- transform(regmap.markers,
                            chr = factor(chr),
                            pos = as.numeric(pos))
out <- t(out[,-(1:2)])

# Convert the genotype data to a binary matrix.
cat("Converting genotype data to a binary matrix.\n")
n           <- nrow(out)
p           <- ncol(out)
regmap.geno <- matrix(0,n,p)
ids         <- rownames(out)
rownames(regmap.geno) <- ids
temp <- system.time({
for (i in 1:p) {
  a               <- names(which.min(table(factor(out[,i]))))
  regmap.geno[,i] <- out[,i] == a
}
})
rm(out,i,a)

# Compute principal components of genotype matrix using rsvd.
cat("Computing top 20 PCs of genotype matrix.\n")
set.seed(1)
print(system.time(out <- rpca(X,k = 20,center = TRUE,
                              scale = FALSE,retx = TRUE)))

# Save the sample info and PCs to file.
cat("Writing RegMap data to file.\n")
write.csv(cbind(info[ids,],round(out$x,digits = 4)),"regmap.csv",
          quote = FALSE,row.names = FALSE)
