#include <R.h>
#include <Rinternals.h>

extern void openblas_set_num_threads (int);
extern void omp_set_dynamic (int);

SEXP set_blas_Call (SEXP np) {
  int n = *INTEGER(np);
  omp_set_dynamic(0);
  openblas_set_num_threads(n);
  return R_NilValue;
}
