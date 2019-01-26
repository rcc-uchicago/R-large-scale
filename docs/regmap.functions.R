# Read the RegMap phenotype data from a text file. This should produce
# a data frame with 948 rows (samples) and 48 columns (phenotypes).
read.regmap.pheno <- function (filename) {
  out        <- read.table(filename,sep = "\t",header = TRUE,comment = "#",
                           stringsAsFactors = FALSE,check.names = FALSE)
  phenotypes <- out$phenotype
  out        <- as.data.frame(t(out[-1]))
  names(out) <- phenotypes
  return(out)
}

# Read from a text file the following info on the RegMap samples:
# array id, ecotype id, genotyping intensity, geographic co-ordinates
# (latitude and longitude), region label, and country label. This
# should produce a data frame with 1,307 rows (samples) and 6 columns.
read.regmap.info <- function (filename) {
  out <- read.table(filename,sep = "\t",header = TRUE,quote = "",
                    comment = "#",as.is = c("nativename","region"))
  ids <- out$array_id
  out <- out[c("ecotype_id","median_intensity","latitude","longitude",
               "region","country")]
  rownames(out) <- ids

  # If the region is the empty string, set it to missing. Then set
  # this column to a factor.
  rows <- which(out$region == "")
  out[rows,"region"] <- NA
  return(transform(out,region = factor(region)))
}

# Read the RegMap genotype data and marker information from a CSV file.
read.regmap.geno <- function (filename) {
  geno <- fread(filename,sep = ",",header = TRUE,stringsAsFactors = FALSE,
                verbose = FALSE,showProgress = FALSE)
  class(geno)    <- "data.frame"
  geno           <- geno[-1,]
  markers        <- geno[,1:2]
  names(markers) <- c("chr","pos")
  markers        <- transform(markers,
                              chr = factor(chr),
                              pos = as.numeric(pos))
  geno           <- t(geno[,-(1:2)])
  return(list(markers = markers,geno = geno))
}

# Convert the RegMap genotype data to a binary matrix.
regmap.geno.as.binary <- function (dat) {
  n   <- nrow(dat)
  p   <- ncol(dat)
  out <- matrix(0,n,p)
  ids <- rownames(dat)
  rownames(out) <- ids

  # Repeat for each column (i.e., genetic variant).
  for (i in 1:p) {
    a       <- names(which.min(table(factor(dat[,i]))))
    out[,i] <- dat[,i] == a
  }
  
  return(out)
}
