/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * base10toM.c
 *
 * Code generation for function 'base10toM'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "base10toM.h"
#include "base10toM_emxutil.h"
#include "base10toM_data.h"

/* Variable Definitions */
static emlrtRTEInfo emlrtRTEI = { 1,   /* lineNo */
  18,                                  /* colNo */
  "base10toM",                         /* fName */
  "C:\\Users\\oizumi\\Documents\\GitHub\\PhiToolbox\\base10toM.m"/* pName */
};

static emlrtDCInfo emlrtDCI = { 25,    /* lineNo */
  15,                                  /* colNo */
  "base10toM",                         /* fName */
  "C:\\Users\\oizumi\\Documents\\GitHub\\PhiToolbox\\base10toM.m",/* pName */
  4                                    /* checkKind */
};

static emlrtDCInfo b_emlrtDCI = { 25,  /* lineNo */
  15,                                  /* colNo */
  "base10toM",                         /* fName */
  "C:\\Users\\oizumi\\Documents\\GitHub\\PhiToolbox\\base10toM.m",/* pName */
  1                                    /* checkKind */
};

static emlrtRTEInfo c_emlrtRTEI = { 27,/* lineNo */
  7,                                   /* colNo */
  "base10toM",                         /* fName */
  "C:\\Users\\oizumi\\Documents\\GitHub\\PhiToolbox\\base10toM.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  28,                                  /* lineNo */
  11,                                  /* colNo */
  "sigma",                             /* aName */
  "base10toM",                         /* fName */
  "C:\\Users\\oizumi\\Documents\\GitHub\\PhiToolbox\\base10toM.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void base10toM(const emlrtStack *sp, real_T C, real_T N, real_T M,
               emxArray_real_T *sigma)
{
  int32_T i0;
  int32_T i;

  /* ------------------------------------------------------------------------------------------------- */
  /*  PURPOSE: convert base 10 to base M */
  /*  */
  /*  INPUTS: */
  /*    C: decimal value */
  /*    N: the number of digits */
  /*    M: base */
  /*  */
  /*  OUTPUTS: */
  /*   sigma: base M value */
  /* ------------------------------------------------------------------------------------------------- */
  /*  */
  /*  Masafumi Oizumi, 2018 */
  if (!(N >= 0.0)) {
    emlrtNonNegativeCheckR2012b(N, &emlrtDCI, sp);
  }

  if (N != (int32_T)muDoubleScalarFloor(N)) {
    emlrtIntegerCheckR2012b(N, &b_emlrtDCI, sp);
  }

  emlrtForLoopVectorCheckR2012b(1.0, 1.0, N, mxDOUBLE_CLASS, (int32_T)N,
    &c_emlrtRTEI, sp);
  i0 = sigma->size[0];
  sigma->size[0] = (int32_T)N;
  emxEnsureCapacity_real_T(sp, sigma, i0, &emlrtRTEI);
  i = 0;
  while (i <= (int32_T)N - 1) {
    i0 = sigma->size[0];
    if (!((i + 1 >= 1) && (i + 1 <= i0))) {
      emlrtDynamicBoundsCheckR2012b(i + 1, 1, i0, &emlrtBCI, sp);
    }

    sigma->data[i] = C - muDoubleScalarFloor(C / M) * M;
    C = muDoubleScalarFloor(C / M);
    i++;
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(sp);
    }
  }
}

/* End of code generation (base10toM.c) */
