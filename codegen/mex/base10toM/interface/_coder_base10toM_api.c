/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_base10toM_api.c
 *
 * Code generation for function '_coder_base10toM_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "base10toM.h"
#include "_coder_base10toM_api.h"
#include "base10toM_emxutil.h"
#include "base10toM_data.h"

/* Variable Definitions */
static emlrtRTEInfo b_emlrtRTEI = { 1, /* lineNo */
  1,                                   /* colNo */
  "_coder_base10toM_api",              /* fName */
  ""                                   /* pName */
};

/* Function Declarations */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *C, const
  char_T *identifier);
static const mxArray *emlrt_marshallOut(const emxArray_real_T *u);

/* Function Definitions */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *C, const
  char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(C), &thisId);
  emlrtDestroyArray(&C);
  return y;
}

static const mxArray *emlrt_marshallOut(const emxArray_real_T *u)
{
  const mxArray *y;
  const mxArray *m0;
  static const int32_T iv0[1] = { 0 };

  y = NULL;
  m0 = emlrtCreateNumericArray(1, iv0, mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m0, (void *)&u->data[0]);
  emlrtSetDimensions((mxArray *)m0, u->size, 1);
  emlrtAssign(&y, m0);
  return y;
}

void base10toM_api(const mxArray * const prhs[3], const mxArray *plhs[1])
{
  emxArray_real_T *sigma;
  real_T C;
  real_T N;
  real_T M;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtHeapReferenceStackEnterFcnR2012b(&st);
  emxInit_real_T(&st, &sigma, 1, &b_emlrtRTEI, true);

  /* Marshall function inputs */
  C = emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "C");
  N = emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "N");
  M = emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "M");

  /* Invoke the target function */
  base10toM(&st, C, N, M, sigma);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(sigma);
  sigma->canFreeData = false;
  emxFree_real_T(&sigma);
  emlrtHeapReferenceStackLeaveFcnR2012b(&st);
}

/* End of code generation (_coder_base10toM_api.c) */
