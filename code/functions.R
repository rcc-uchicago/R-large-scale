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

# Read the RegMap phenotype data from a text file. This should produce
# a data frame with 948 rows (samples) and 48 columns (phenotypes).
read.regmap.pheno <- function (filename) {
  out <- read.table(filename,sep = "\t",header = TRUE,comment = "#",
                    quote = "",stringsAsFactors = FALSE,check.names = FALSE)
  out <- as.data.frame(t(out[-1]))
  names(out) <- out$phenotype
  return(out)
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

# Create scatterplot from two selected columns (x, y) in data frame
# (dat). Also, vary shape and color according to column z. Column z
# should be a factor.
scatterplot.vary.shapeandcolor <- function (dat, x, y, z) {
  colors <- c("#E69F00","#56B4E9","#009E73","#F0E442","#0072B2",
              "#D55E00","#CC79A7")
  shapes <- c(19,17,8,1,3)
  n      <- nlevels(dat[[z]])
  colors <- rep(colors,length.out = n)
  shapes <- rep(shapes,length.out = n)
  return(ggplot(data = dat,
                 mapping = aes_string(x = x,y = y,color = z,shape = z),
                 environment = environment()) +
           geom_point(size = 3) +
           scale_color_manual(values = colors) +
           scale_shape_manual(values = shapes))
}

# This function distributes the elements of `x` evenly (or as evenly
# as possible) into `k` list elements.
distribute <- function (x, k)
  split(x,rep(1:k,length.out = length(x)))

# This function replicates vector x to create an n x m matrix, where m
# = length(x).
rep.row <- function (x, n)
  matrix(x,n,length(x),byrow = TRUE)

# Center the columns of matrix X so that the mean of each column is
# zero.
center.cols <- function (X)
  X - rep.row(colMeans(X),nrow(X))

# This function takes as input an array of unnormalized log-importance
# weights and returns normalized importance weights such that the sum
# of the normalized importance weights is equal to 1. We guard against
# underflow or overflow by adjusting the log-importance weights so
# that the largest importance weight is 1.
normalizelogweights <- function (logw) {
  c <- max(logw)
  w <- exp(logw - c)
  return(w/sum(w))
}

# Returns a c% credible interval [a,b], in which c is a number between
# 0 and 1. Precisely, we define the credible interval [a,b] to be the
# smallest interval containing x0 that contains c% of the probability
# mass. (Note that the credible interval is not necessarily symmetric
# about x0. Other definitions of the credible interval are possible.)
# By default, c = 0.95. Input x is the vector of random variable
# assignments, and w contains the corresponding probabilities. (These
# probabilities need not be normalized.) Inputs x and w must be
# numeric arrays with the same number of elements.
cred <- function  (x, x0, w = NULL, cred.int = 0.95) {

  # Get the number of points.
  n <- length(x)

  # By default, all samples have the same weight.
  if (is.null(w))
    w <- rep(1/n,n)

  # Convert the inputs x and w to vectors.
  x <- c(x)
  w <- c(w)

  # Make sure the probabilities sum to 1.
  w <- w/sum(w)

  # Sort the points in increasing order.
  i <- order(x)
  x <- x[i]
  w <- w[i]
  
  # Generate all possible intervals [a,b] from the set of points x.
  a <- matrix(1:n,n,n,byrow = TRUE)
  b <- matrix(1:n,n,n,byrow = FALSE)
  i <- which(a <= b)
  a <- a[i]
  b <- b[i]

  # Select only the intervals [a,b] that contain x0.
  i <- which(x[a] <= x0 & x0 <= x[b])
  a <- a[i]
  b <- b[i]

  # Select only the intervals that contain cred.int % of the mass.
  p <- cumsum(w)
  i <- which(p[b] - p[a] + w[a] >= cred.int);
  a <- a[i]
  b <- b[i]

  # From the remaining intervals, choose the interval that has the
  # smallest width.
  i <- which.min(x[b] - x[a])
  return(list(a = x[a[i]],b = x[b[i]]))
}

# For each PVE setting h, get the prior variance of the regression
# coefficients assuming a fully "polygenic" model.
get.prior.variances <- function (X, h) {
  sx <- sum(apply(X,2,sd)^2)
  return(ncol(X)*h/(1-h)/sx)
}

# This function computes the marginal log-likelihood the regression
# model of Y given X assuming that the prior variance of the
# regression coefficients is sa. Here K is the "kinship" matrix, K =
# tcrossprod(X)/ncol(X). Also, note that H is the covariance matrix of
# Y divided by residual variance.
compute.log.weight <- function (K, y, sa, use.backsolve = TRUE) {
  n <- length(y)
  H <- diag(n) + sa*K
  R <- tryCatch(chol(H),error = function(e) FALSE)
  if (is.matrix(R)) {
    x    <- backsolve(R,forwardsolve(t(R),y))
    logw <- (-determinant(sum(y*x)*H,logarithm = TRUE)$modulus/2)
  } else
    logw <- 0
  return(logw)
}

# This function computes the marginal log-likelihood for multiple
# settings of the prior variance parameter.
compute.log.weights <- function (K, y, sa)
  sapply(as.list(sa),function (x) compute.log.weight(K,y,x))

# This is a multicore variant of the above function implemented using
# the "mclapply" function. Input argument `nc` specifies the number of
# cores (CPUs) to use for the computation. Note that the mclapply
# relies on forking and therefore will not work on a computer running
# Windows.
compute.log.weights.multicore <- function (K, y, sa, nc = 1) {
  samples <- distribute(1:length(sa),nc)
  logw    <- mclapply(samples,
               function (i) compute.log.weights(K,y,sa[i]),
               mc.cores = nc)
  logw <- do.call(c,logw)
  logw[unlist(samples)] <- logw
  return(logw)
}

# This function sets the number of threads used by OpenBLAS.
set.blas.num.threads <- function (n) {
  .Call("set_blas_Call",n = as.integer(n))
  return(n)
}
