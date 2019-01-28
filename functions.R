# TO DO: Explain here what this function does.
get.assoc.pvalue <- function (x, y)
  summary(lm(y ~ x,data.frame(x = x,y = y)))$coefficients["x","Pr(>|t|)"]

