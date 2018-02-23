/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * baseMto10.c
 *
 * Code generation for function 'baseMto10'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "baseMto10.h"
#include "baseMto10_data.h"

/* Variable Definitions */
static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  27,                                  /* lineNo */
  27,                                  /* colNo */
  "sigma",                             /* aName */
  "baseMto10",                         /* fName */
  "C:\\Users\\oizumi\\Documents\\GitHub\\PhiToolbox\\baseMto10.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
real_T baseMto10(const emlrtStack *sp, const real_T sigma_data[], const int32_T
                 sigma_size[2], real_T M)
{
  real_T x;
  int32_T n;
  int32_T i;
  int32_T i0;
  int32_T i1;

  /* ------------------------------------------------------------------------------------------------- */
  /*  PURPOSE: convert base M to base 10 */
  /*  */
  /*  INPUTS: */
  /*    sigma: base M value */
  /*    M: base */
  /*  */
  /*  OUTPUTS: */
  /*   x: decimal value */
  /* ------------------------------------------------------------------------------------------------- */
  /*  */
  /*  Masafumi Oizumi, 2018 */
  if ((sigma_size[0] == 0) || (sigma_size[1] == 0)) {
    n = 0;
  } else {
    n = muIntScalarMax_sint32(sigma_size[0], 1);
  }

  x = 0.0;
  i = 0;
  while (i <= n - 1) {
    i0 = sigma_size[0] * sigma_size[1];
    i1 = 1 + i;
    if (!(i1 <= i0)) {
      emlrtDynamicBoundsCheckR2012b(i1, 1, i0, &emlrtBCI, sp);
    }

    x += muDoubleScalarPower(M, (1.0 + (real_T)i) - 1.0) * sigma_data[i1 - 1];
    i++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }

  return x;
}

/* End of code generation (baseMto10.c) */
