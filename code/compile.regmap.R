# Script to compile the RegMap data.
#
# Before running this script, download the RegMap data from 
# bergelson.uchicago.edu/wp-content/uploads/2015/04/call_method_75.tar.gz
# and extract the file call_method_75_TAIR9.csv into the "data" directory.
#
library(methods)
library(data.table)
source("functions.R")

# LOAD SAMPLE INFO
# ----------------
# Retrieve the following sample info: array id, ecotype id, genotyping
# intensity, geographic co-ordinates (latitude and longitude), region
# label, and country label. This should produce a data frame with
# 1,307 rows (samples) and 6 columns.
cat("Reading sample info.\n")
regmap.info <- read.regmap.info("../data/call_method_75_info.tsv")

# LOAD PHENOTYPE DATA
# -------------------
# This should produce a data frame, "regmap.pheno" , with 948 rows
# (samples) and 48 columns (phenotypes).
cat("Reading phenotype data.\n")
regmap.pheno <- read.regmap.pheno("../data/allvars948_notnormd_011311.txt")
  
# LOAD GENOTYPE DATA
# ------------------
# Load the genotype data and information about the genetic markers.
cat("Reading genotype data.\n")
out <- read.regmap.geno("../data/call_method_75_TAIR9.csv")
regmap.markers <- out$markers
regmap.geno    <- out$geno
rm(out)

# Convert the genotype data to a binary matrix.
cat("Converting genotype data to a binary matrix.\n")
regmap.geno <- regmap.geno.as.binary(regmap.geno)

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
