@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2017b
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2017b\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=baseMto10_mex
set MEX_NAME=baseMto10_mex
set MEX_EXT=.mexw64
call "C:\PROGRA~1\MATLAB\R2017b\sys\lcc64\lcc64\mex\lcc64opts.bat"
echo # Make settings for baseMto10 > baseMto10_mex.mki
echo COMPILER=%COMPILER%>> baseMto10_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> baseMto10_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> baseMto10_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> baseMto10_mex.mki
echo LINKER=%LINKER%>> baseMto10_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> baseMto10_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> baseMto10_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> baseMto10_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> baseMto10_mex.mki
echo OMPFLAGS= >> baseMto10_mex.mki
echo OMPLINKFLAGS= >> baseMto10_mex.mki
echo EMC_COMPILER=lcc64>> baseMto10_mex.mki
echo EMC_CONFIG=optim>> baseMto10_mex.mki
"C:\Program Files\MATLAB\R2017b\bin\win64\gmake" -B -f baseMto10_mex.mk
