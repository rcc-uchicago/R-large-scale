#include <Rcpp.h>

using namespace Rcpp;

// The same as scale(X,center = TRUE,scale = TRUE), except that the
// input matrix X is modified directly. The return value can be
// ignored; it is always zero.
//
// Input argument "a" must be the vector of column means, and input
// "b" must be the vector of column standard deviations.
//
// [[Rcpp::export]]
double scale_rcpp (NumericMatrix& X, NumericVector& a, NumericVector& b) {
  int    nr = X.nrow();
  int    nc = X.ncol();
  int    i, j;
  double aj, bj;

  for(j = 0; j < nc; j++) {
    aj = a(j);
    bj = b(j);
    for(i = 0; i < nr; i++)
      X(i,j) = (X(i,j) - aj) / bj;
  }

  return 0;
}
