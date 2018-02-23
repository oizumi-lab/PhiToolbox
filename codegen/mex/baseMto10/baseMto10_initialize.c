/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * baseMto10_initialize.c
 *
 * Code generation for function 'baseMto10_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "baseMto10.h"
#include "baseMto10_initialize.h"
#include "_coder_baseMto10_mex.h"
#include "baseMto10_data.h"

/* Function Definitions */
void baseMto10_initialize(void)
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

/* End of code generation (baseMto10_initialize.c) */
