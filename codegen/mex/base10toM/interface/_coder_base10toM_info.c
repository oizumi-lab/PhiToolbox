/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_base10toM_info.c
 *
 * Code generation for function '_coder_base10toM_info'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "base10toM.h"
#include "_coder_base10toM_info.h"

/* Function Definitions */
mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xResult;
  mxArray *xEntryPoints;
  const char * fldNames[4] = { "Name", "NumberOfInputs", "NumberOfOutputs",
    "ConstantInputs" };

  mxArray *xInputs;
  const char * b_fldNames[4] = { "Version", "ResolvedFunctions", "EntryPoints",
    "CoverageInfo" };

  xEntryPoints = emlrtCreateStructMatrix(1, 1, 4, fldNames);
  xInputs = emlrtCreateLogicalMatrix(1, 3);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString("base10toM"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", emlrtMxCreateDoubleScalar(3.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs", emlrtMxCreateDoubleScalar
                (1.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  xResult = emlrtCreateStructMatrix(1, 1, 4, b_fldNames);
  emlrtSetField(xResult, 0, "Version", emlrtMxCreateString(
    "9.3.0.713579 (R2017b)"));
  emlrtSetField(xResult, 0, "ResolvedFunctions", (mxArray *)
                emlrtMexFcnResolvedFunctionsInfo());
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

const mxArray *emlrtMexFcnResolvedFunctionsInfo(void)
{
  const mxArray *nameCaptureInfo;
  const char * data[15] = {
    "789ced5dcd8fda461477924d9a48fd40addaa6eaa1511aadd2a6c2090bcb6ed4aac062021b7697cf64d934da1833c0646d0ff883404e7b6c4f8dd453a51e72ec"
    "a5528f3dee317f40db43ff8748bd55bd15b0cde22923886c4c8019090dc3b3e7f7fcf6cd6f669e9fbdcc99d4ce198661deee7e7af53391e997b78c8af199f559",
    "c65e70f919b37e176b5be53cb3623bcf92ff64d6029235d0d68c860865b0ab4b65a0741b322f8141371524419997b542a7011805a8486c814a5f528522284009"
    "a4d1502309bb0d2931241a347aa2def7ad3a108ef2bac42875f5545d71b8c10cd9e739e1fa5726b4cf6d827d7c98fc01f770eb365b5481a2b2083ed525c8c691",
    "a04b40d654f60ed4927a99cdd4610121b18cda6c9957c1ad9b1adaf14b767ddb047d2e4ca8ef3982be97ccfab2edd750c4a8d7cd3a1cb1f47844c099d46e243d"
    "7ca684170dc7750bef0d229e2111510d0abc38c0fbd9211e47c4b3cb1fa4d2fb7dd7c828a8a6f0d2959e0fabec4eb4908ec6d85ce0e6ad7099d54caf0092c88a",
    "b0cc4abc26f265163554b66ba7be8b8cb3d3a4fe81d756b9c45c34bf1db7573ffa23ea1d9e5196058f34be27f5bb0f08783e4c5e0a2b4d617bb7d28ac1361f08"
    "a5f9120a56b64ef5c88cc119a70743687bd53f1dbff662f7b7ab031e3f26f437a99d3e21e0f930b9802a40f1c3eea2409179d10fd5980e452d257797054081c2",
    "cc78fe378778fb443cbbfc95fda4f7b9d1b71a7bc3321b8b9bcd2f79c8fbe75efc45797fde797fafd5dc8a5693ad8d4236d81138490e240ec424e5fde5e0fdeb"
    "11b7fced43029e0f9363bcdfbdec3d252a775ce3fb15ac7daa872111ea7c6fd339c0fbd5215e066b33d87196dc1dbeb7cce525cf33ab3fbcf727e5f929e179c5",
    "f381604d936ae85e202ec36d10df016bc9a89e581c9ea7e378b4fe36bf3b8eb816af19b7ae862a68ea43eb6aa77817b0f6299e21a920bd2c02f7fce12e11cf2e"
    "7732ef03b1fb85352d6506f63c5cbfafd0f5fbfcf37abed8d4b5ddd4bd7bc55c3ebbae34a3c910e06394d797671cf7ca9501af3708fd4d6a2fd2dfc787d55d13",
    "1c9a577c282005cc8ae74f1ce23d24e2d9e53dffc838739086025bbc0658dc745ec7eb533f5ea7ebf979e77d6ebdbcb9fb3891e9dc4f54f3d5fbdc5ef856e968"
    "81e2362784f3e9b8b69769c5732e636d063bce9263f11c99576a5016ea474ee703bc90f4b08a5b7ef3cd183c4bfe4aeb05b5ce2ba0c21abb40732f886f090796",
    "3316101ece07876fe67ea7f3c194f0bc9a0f3aed27a94d3e51ad856e0a7b1cca3f4ee8e1271c9d0f5ed771ed6ddeced58851af9af517aec581ce13f4f09992aa"
    "88502fe03eaf71a01411cf2e77b67facea32dbb79495dee5255f7d776d95c681e69dff379ae1bd42538c878e62f542f64e5e6bc6e3028def2fd3386686e340c7",
    "84fee6358fe755799fe6f18caead42f378bcc1a3793ceef44ff97fb4fe76bfbbe61aff7f4cc0f361728cff55811779c56fadfa9daffbf132691cc829ff17c7e0"
    "597277f8ff8661b721dff190ff159abf3ffffc5faeaf67f66551abe491c4e97272adccc5b6ef50fe5f56fe7f46e86f527b7d46c0f361723c9fb3d1103bf93e99",
    "257459d02092537246e405eb113fb7ee53bf33463f4b5e35b538acf372a5bb41b0f05f38c42f8fc1b7e42ee58b11cd8a3f0ff888a0b78b7ef6fdfd10bd7f3cef"
    "f3457afbae506a6636a3a59da0a2061a30d00a6fc71767bea0e37bf4754de68ffe85db47cc2a8e44f711d3c233cab2e0d17d843bfd3bdd4764b036831d67c9e7",
    "fb3981f880ffbf25f437a9bd3e25e0f93039c6ff0292556d17c97928d744a021390e8d897056cf059f38c49b4afe01d16f4699cfebbc22fadcd834f1bc9a0fb6"
    "c245495803013998cde5b866435917aa6b0b341f3c279cffbabeef87143799d4cfce626dab587943f678fa9711a3fecab57ca18b589b191c674824a5025bb032",
    "b3e7099cae0fb6897876b9d3e7c52d3bf94d87f09087fefde5e142f37a6796fb18a7bcfe3e01cf87c9dba58303ae16854a33d892b850a114cd3ee699c5e1753a"
    "8e47eb6ff7bbbfbff66a3d6d5e26cd031de30f963b787fffe8f89f97191abf99775edf7892ad16f783ebe1644bcc6dc63736d2a8283094d75f9771ecedfafd6a",
    "c4a857695ea8790ccd0b1d5d5b85e6857a8347f342dde97fdee7834704fddcf5bbcf5de3ff2b043c1f261f713f17b41b5b486af01aec32f2acf8ffc4215e8988"
    "6797bbc3ffff33db2cfc87c6f1a788e7d53c50af349483fda79c500bc7d3e1ce9ace47b31bf43d414b360fdc76edfd10a4ff03e1c3e4d83cd0bd7ae3f7798d03",
    "4ded7d5223f9bf6b2eefdf2745f97e8a785ef17d2d16eb54c26b1c77d00eb492770b305e52720bb4ee7f4e389fdeb7ed15f7efdbd2f73c18658e9f0fa1ef7998"
    "221e7dcf83b3feff036b5043f8", "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(data, 27816U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/* End of code generation (_coder_base10toM_info.c) */
