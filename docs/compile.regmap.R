# Script to compile the RegMap data.
#
# Before running this script, download the RegMap genotype data from here:
#
#   bergelson.uchicago.edu/wp-content/uploads/2015/04/call_method_75.tar.gz
#
library(data.table)
source("compile.regmap.functions.R")

# LOAD PHENOTYPE DATA
# -------------------
# This should produce a data frame with 948 rows (samples) and 48
# columns (phenotypes).
cat("Reading phenotype data.\n")
pheno <- read.regmap.pheno("allvars948_notnormd_011311.txt")

# LOAD GENOTYPE DATA
# ------------------
# Load the genotype data and information about the genetic markers.
cat("Reading genotype data.\n")
out     <- read.regmap.geno("call_method_75_TAIR9.csv")
geno    <- out$geno
markers <- out$markers

# LOAD GENOTYPE SAMPLE INFO
# -------------------------
# Retrieve the following sample info: array id, ecotype id, genotyping
# intensity, geographic co-ordinates (latitude and longitude), region
# label, and country label. This should produce a data frame with
# 1,307 rows (samples) and 6 columns.
cat("Reading sample info.\n")
info <- read.regmap.info("call_method_75_info.tsv")


# Convert the genotype data to a binary matrix.
cat("Converting genotype data to a binary matrix.\n")
geno <- regmap.geno.as.binary(geno)

stop()

# Reorder the rows of regmap.info so that they match up with the rows
# of regmap.geno.
rows        <- match(rownames(regmap.geno),rownames(regmap.info))
regmap.info <- regmap.info[rows,]

# WRITE DATA TO CSV FILES
# -----------------------
# TO DO.
