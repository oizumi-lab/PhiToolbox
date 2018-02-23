/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_baseMto10_info.c
 *
 * Code generation for function '_coder_baseMto10_info'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "baseMto10.h"
#include "_coder_baseMto10_info.h"

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
  xInputs = emlrtCreateLogicalMatrix(1, 2);
  emlrtSetField(xEntryPoints, 0, "Name", emlrtMxCreateString("baseMto10"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs", emlrtMxCreateDoubleScalar(2.0));
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
  const char * data[23] = {
    "789ced5dcd6f234915ef999d596625162cf1b5080976865534ab41697f259e2c07e2c476e224fe7662c7cb2a69b7db764dbaabeceeb663e7640909c109244e48"
    "1ce606472e487b0c1758892b20b4e2b02704ff05b6db9da44bae7567badc4e3b555254ae79edfa95dfbcfa55d5eb5755dc8364ea01c7715f1bfe3d1cfe717fe1",
    "c6e95d23e37c93fc21674db8fcc1247f8a95cdf4987b64f99e29ffdd241711d4a59e6e146400a57447a94aeab0000545baaaa686140005a817fb2d8953250dc9"
    "5da93696d4812c1581221da01b855d302c28891ba2abc24834fabcdd94c4b34247e1d4a676dd5cf96681bba19fd784dfffc8a67e3e22e8c787c93f8e7fb2fd11",
    "7fa849aac62370d151001f43624791a0aef13b40dfed54f96c13141192aba8c757054d4ae928e05f55aced6d11daf3b6cdf63ec4ca667a077bde48e14d235fdb"
    "34f14f09f5dbd5d75b047cdf4422c8f238a785f715229e2191510388827c85f707877871229e55fe71f2a03c3689ac8a1aaaa0bc3fb25d8d4f458b07d12d3e1f",
    "f40722555e9f5883a4c8bc0caabc22e8b250e5514be3877a1a9bc62c3dd9b50b3c37d33bdc93c9a7416fe5bbff88ba8767a4fb82d723d467d7eebe4dc0f361f2"
    "e388da16f7d2b5ee16e809c1b503e118856bdbd7edc8cec099d50e8e5076ab7ed67fadc96a6fcfae787c40a8cfae9e7e40c0f3617211d52475150c27032a14e4",
    "55a06d7580ac27e1703a20a9405c18cf7fea10af4cc4b3ca6f6d27a3bf1763adf12f4cb5f1b8da56151779ffadcf3e67bcef75decf74dbdbd1fa6ef7653117ee"
    "8b71050613157997f1fefde0fde79bb4eced3b043c1f26c7787ff8b3336a14f6a9f1fd23ac7cdd0e43223685d162f30aef8f0ef1b25899c39e33e574f8de5497",
    "9b3ccfadfce61bff643c3f273cb7783e186ee84a031d056310ec49b19414da8d7612cbc3f3ac1f4f6fbfc5ee069bd4fc35b3e6d54093da9d1bf36aa7786f63e5"
    "6b3c4352439daa2cd1b3877d229e55ee64dc97e4e1077ea2a98943cfc5f9fb23367ff73eaf170edb1d3d9d3c3a3acc1772eb6a3bbabb26095b8cd7ef4f3f1ea5",
    "f7af78bd45a8cfaebe48ff3f3e2c1faae064f28b4f44a44a8be2f94b87789f10f1acf2917d649d19484b055d4197785c756efbeb93bf7dcee6f35ee7fdf87a75"
    "23fd2a91ed9712f542bd14cf4402c7674be4b7b9247c9ff56b6b9a973fe73d029e0f9363fe1c28a80d00c5e699d3f1004fa476988996ddfc74069e29bfd57c41",
    "6b0aaa54e38d55e0642d882f09af34674c205c1c0f4ebe9aff3b1b0fe684e7d678d0ef9d27378444bdb1e6173371547895e844cee36c3cb8abfd9a641776ed90"
    "142f63c6ebbc67f9d7679b46be32c97f44cd0ff498d00edf445297111a39dcbdea074a12f1ac7267ebc77a07f2634d99615d6ef2d52f3f58617e20aff3ffcb76",
    "24536ccbb1b5b3ad6631b753d0dbb198c8fcfbf7a91f7337fd4003427d5e8de3b92defb3389ee9b999581c8f3b782c8e874efd8cffa7b7df6a771f50e3ffef11"
    "f07c981ce37f4d1464415d3567fdcee7fd78b2eb0772caff8733f04c391dfe7f61e8ed86edb8c8ff2a8bdff73eff579bebd93294f55a0129f10edc0d55e35b7b",
    "3b8cffef2bffff9a509f5d7d7d48c0f361723c9eb3d592fb853199253a50d4018249989505d1dcda47eb3df5d767b4cf94d727ad38690ab0365c2098f89f39c4"
    "afcec037e594e2c5886ac5f7019e12da4dd1ce7e555a63ef8fbd3e5e1ceced8bc7edec46f4381556b5600b04bb91bdd8f28c17ac7f4fff5df6ec7175e9d6118b",
    "f223b175c4bcf08c745ff0d83a824efd4ed71159accc61cf99726fef13885df1ff2f08f5d9d5d70f09783e4c8ef1bf88a0a6a7112c00d890251dc1183006c245"
    "ed0bbe74883797f803a2dd4c539fdb71456cdfd83cf1dc1a0fb623878a189282309ccbe7e3ed96ba2ed6434b341ebc267cffae9ef3734a680f5d3b8b508b23fd",
    "1601cf87c931fe9725d8d09bdce2de1f389d27a467e099723a7c6fa86b642b8cdf9703cfad7e573c38aa6c28b5b21a2d8523bd40e848f1a7f739c6efcbcdef3f"
    "a616ff39cb9fa2b4d0f9e878bf45f96f9c9effb14bc4b3ca9d9eff61e8c9d5b89fbf96828cbfef2a7fdb9d9fb7e146ba9047a87f9e7db923042a3086aad212c5",
    "fd7bb5ffb608ed9acf799cfe4d230fb2f84f8ec57fde6cb78d7180c57fce118fc57fd2a9dfabe3c029a15d74eded27d4e6f34fb03277f59c2101daf0c7aaa0e7"
    "d5fd5c07443cab9cc6792086a65cf7bb27feccf8dcf37cded5c5940ad0a1b216bc806747071be7a9f2ee12ede7627c6e4d567b8b51e3f359fb7327ee19cffa67",
    "76887856b9533b9898819bf134fffafd3af3cf789dc74bcd2369bd902bace58bb94e39b65f3942854376aefec2fbafbbfe99679b46bec2fc331cf3cfdc6c37f3"
    "cf2c168ff967e8d4ef745d9ec5ca1cf69c29a7340e3cadcbfaf8a3bb7195296a71356f78debe111f1e6f78f63c9eb9d9c954de37d5e52adfff0ffd9bf1bdd7f9",
    "de9f3e8f2845a054f641be16df8f89857abdbfc5f8fefef463cec2f7a4f5865d7dbd8b9539ec39530e34684c51f5d1cd99de3d772d43c4b3cadf683e50073da9"
    "d64243f3e02dfa72d5bfc375d87e29eff3fc4ee8ac5f683780bc5ddc3ecbb7b71ac5b3c3f812eda3653c3fbdfd249e27e1d17bff5a07c3e54cd3abbcbe47c4b3",
    "ca9df3baa1a705c4d7325e9f239e5b71f1ddb6146f75456da37c1e4228ab1502a1e30ab73cbcee2dffeb35af3fad0355d3ebc055fbbb3ca5e6b7ff3e01cf87c9"
    "c7970940fda48e5419a1d609ea4a6a5d46e727e2e81efbc5ed8bba7c433cb3fe53ac8ce3997247f13786197d89fe5cf5e73cf9f4317b8f7b57c703bbf37c6d3f",
    "de8bc72e2eb27bbd603815f46fe7a201ff12c5d9ff97f07dbb7afc39a17e1f269f77bf7efae50f9c3425b965673f125d7bdda1b63e9875bfed68de3bca17fc9e"
    "01c09ad44b429d5a9c4062463b4c398d7583cbfb68d93d8c73c473ed1ec67e0b286bed7c2900aab570b292cba602dd25f203b1fe6b4d567bf32f8d9fdfedfbd3",
    "999f9f3ade38dd173ce6e7a7533f9bff5bdb4bd75e93ae9db730fce98ad0f3ee7830d7f703d6fd59634db9ff7e6030f8cf13e60ff2fa78a0b6fdad57400b4795"
    "f56c0466abe5d0fe91b644f13d6c3cb0b697eefb6277c70300d978606f3c007001e3c1cfd878e0fdf1a0211c4732a152ba1da946f5ed35211396c2b9253a2793",
    "bd2f9e9e9bc9627f5f9c52e3f7dbfafb9de2b9bd7f7789fd82ccaf3f473ce6d7a753bfd3f959162b73d873a6dcd3fbb6b8ebf84ea7e7e13f27e0f930f9b47bb5"
    "b6001454ec9a185aef1d167d9f963003df9453bc6f679a3a17706fdbe04f5fb0731e3c3f4e5c48028ac274a8a2371ac11d7f2a533b2c0596689cb8247cdfae1e",
    "2b84fa7d989cd63861ac004eea3212f413f3901bce653bbcacb0fdbe0ef1e636bfb833fb47d87edf79e2b1fdbe74ea77eaff2911eaf761725afc0f919e16d219"
    "3539ecda8d21f9bbebdf2f51f3ffcc3abf0d6850809c77f7f9ba732fb3711ee750538b98df333fd01cf1dcda0fd68e76324ab85f0efbf36ab0b31d9036ba4a9a",
    "5b1e7e67fd787afb49f7ab0f08f5b1f3dbece1b1f3dbe68567a4fb82c7ce6fa3533f9bdf4fcfcd449adf0f08f5b1fbd1ede1b1fbd1e78567a4fb82c7ee47a753"
    "ff9df5d7dea5f7c1833435bffe3709783e4c8ef1bfa4aac8126779eab01db78debbc93f37f6dd848a9c61bac3fe17e7c08186bced5f9ffdf5eafb0f7bb5ee77d",
    "583cce09c1e3dd4aa8dbedc4cbdd4048d9034b708effff015b37ab29", "" };

  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(data, 50712U, &nameCaptureInfo);
  return nameCaptureInfo;
}

/* End of code generation (_coder_baseMto10_info.c) */
