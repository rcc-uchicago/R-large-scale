# Create a scatterplot from the two selected columns (x, y) in the
# data frame, "dat".
generate.scatterplot <- function (dat, x, y)
  ggplot(data = dat,mapping = aes_string(x = x,y = y),
         environment = environment()) +
    geom_point(shape = 20,size = 3,color = "black")

# Create a scatterplot from the two selected columns (x, y) in the
# data frame, "dat", and vary shape and color according to column
# z. Column z should be a factor.
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
  H <- diag(n) + sa*K
  R <- tryCatch(chol(H),error = function(e) FALSE)
  if (is.matrix(R)) {
    x    <- backsolve(R,forwardsolve(t(R),y))
    logw <- (-determinant(sum(y*x)*H,logarithm = TRUE)$modulus/2)
  } else
    logw <- 0
  return(logw)
}
