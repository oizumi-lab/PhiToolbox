/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * base10toM_initialize.c
 *
 * Code generation for function 'base10toM_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "base10toM.h"
#include "base10toM_initialize.h"
#include "_coder_base10toM_mex.h"
#include "base10toM_data.h"

/* Function Definitions */
void base10toM_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (base10toM_initialize.c) */
