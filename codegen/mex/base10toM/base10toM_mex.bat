@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2017b
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2017b\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=base10toM_mex
set MEX_NAME=base10toM_mex
set MEX_EXT=.mexw64
call "C:\PROGRA~1\MATLAB\R2017b\sys\lcc64\lcc64\mex\lcc64opts.bat"
echo # Make settings for base10toM > base10toM_mex.mki
echo COMPILER=%COMPILER%>> base10toM_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> base10toM_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> base10toM_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> base10toM_mex.mki
echo LINKER=%LINKER%>> base10toM_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> base10toM_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> base10toM_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> base10toM_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> base10toM_mex.mki
echo OMPFLAGS= >> base10toM_mex.mki
echo OMPLINKFLAGS= >> base10toM_mex.mki
echo EMC_COMPILER=lcc64>> base10toM_mex.mki
echo EMC_CONFIG=optim>> base10toM_mex.mki
"C:\Program Files\MATLAB\R2017b\bin\win64\gmake" -B -f base10toM_mex.mk
