# Script to compile the RegMap data.
#
# Before running this script, download the RegMap data from 
# bergelson.uchicago.edu/wp-content/uploads/2015/04/call_method_75.tar.gz
# and extract the file call_method_75_TAIR9.csv into the "data" directory.
#
library(data.table)

# LOAD SAMPLE INFO
# ----------------
# Retrieve the following sample info: array id, ecotype id, genotyping
# intensity, geographic co-ordinates (latitude and longitude), region
# label, and country label. This should produce a data frame with
# 1,307 rows (samples) and 6 columns.
cat("Reading sample info.\n")
regmap.info <- read.table("../data/call_method_75_info.tsv",sep = "\t",
                      header = TRUE,as.is = c("nativename","region"),
                      quote = "",comment = "#")
ids         <- regmap.info$array_id
regmap.info <- regmap.info[c("ecotype_id","median_intensity","latitude",
                             "longitude","region","country")]
rownames(regmap.info) <- ids

# If the region is the empty string, set it to missing. Then set this
# column to a factor.
rows                       <- which(regmap.info$region == "")
regmap.info[rows,"region"] <- NA
regmap.info                <- transform(regmap.info,region = factor(region))

# LOAD PHENOTYPE DATA
# -------------------
# This should produce a data frame, "regmap.pheno" , with 948 rows
# (samples) and 48 columns (phenotypes).
out <- read.table("../data/allvars948_notnormd_011311.txt",sep = "\t",
                  header = TRUE,comment = "#",quote = "",
                  stringsAsFactors = FALSE,check.names = FALSE)
regmap.pheno        <- as.data.frame(t(out[-1]))
names(regmap.pheno) <- out$phenotype

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
for (i in 1:p) {
  a               <- names(which.min(table(factor(out[,i]))))
  regmap.geno[,i] <- out[,i] == a
}

# Reorder the rows of regmap.info so that they match up with the rows
# of regmap.geno.
rows        <- match(rownames(regmap.geno),rownames(regmap.info))
regmap.info <- regmap.info[rows,]

# SUMMARIZE DATA
# --------------
cat("regmap.info:",paste(dim(regmap.info),collapse = " x "),"\n")
cat("regmap.pheno:",paste(dim(regmap.pheno),collapse = " x "),"\n")
cat("regmap.markers:",paste(dim(regmap.markers),collapse = " x "),"\n")
cat("regmap.geno:",paste(dim(regmap.geno),collapse = " x "),"\n")

# SAVE DATA TO FILE
# -----------------
save(list = c("regmap.info","regmap.pheno","regmap.markers","regmap.geno"),
     file = "regmap.RData")
