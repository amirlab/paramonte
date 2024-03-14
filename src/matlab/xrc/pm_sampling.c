////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//   This file is part of ParaMonte: Parallel Monte Carlo and Machine Learning library.
//
//   Copyright (C) 2012-present, The Computational Data Science Lab
//
//   https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <math.h>
#include <stdint.h>
#include <string.h>
#ifdef _WIN32
#include <Windows.h>
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "mex.h"
#include "matrix.h"
mxArray *matlabFuncHandle;
#define runParaDRAM runParaDRAMD

#if OMP_ENABLED
    double getLogFunc(double logFuncState[], int32_t ndim, int32_t njob, double *avgTimePerFunCall, double *avgCommPerFunCall)
    {
        // Set the MATLAB function input arguments.

        mxArray *argin[2];
        mwSize ndimp1 = ndim + 1;
        argin[0] = matlabFuncHandle;
        argin[1] = mxCreateDoubleMatrix(0, 0, mxREAL);
        //argin[1] = mxCreateDoubleMatrix(ndimp1, njob, mxREAL);
        //memcpy(mxGetDoubles(argin[1]), logFuncState, (ndim + 1) * njob * sizeof(double));
        mxDouble *state = mxMalloc(ndim * njob * sizeof(double));
        mwSize counter = 0;
        for (mwSize ijob = 0; ijob < njob; ijob++) {
            for (mwSize idim = ndimp1 * ijob + 1; idim < ndimp1 * (ijob + 1); idim++) {
                state[counter++] = logFuncState[idim];
                //mexPrintf("state = %f\n", state[counter - 1]);
            }
        }
        mxSetDoubles(argin[1], state); // pointer to state.
        mxSetM(argin[1], ndim);
        mxSetN(argin[1], njob);

        // Get the MATLAB function output arguments.

        mxArray *argout[3];
        mexCallMATLAB(3, argout, 2, argin, "feval");
        mxDestroyArray(argin[1]); // free allocation.

        // Parse the MATLAB function output arguments.

        double *logFunc = mxGetDoubles(argout[0]);
        for (mwSize ijob = 0; ijob < njob; ijob++) {
            logFuncState[ijob * ndimp1] = logFunc[ijob];
            //mexPrintf("logFuncState[ijob * ndim] = %f\n", logFuncState[ijob * ndimp1]);
        }
        *avgTimePerFunCall = mxGetScalar(argout[1]);
        *avgCommPerFunCall = mxGetScalar(argout[2]);
        double mold = 0;
        return mold;
    }
    int32_t runParaDRAM(double(*getLogFunc)(double logFuncState[], int32_t ndim, int32_t njob, double *avgTimePerFunCall, double *avgCommPerFunCall), const int32_t ndim, const char* input);
#else
    double getLogFunc(double state[], int32_t ndim)
    {
        // Set the MATLAB function input arguments.

        mxArray *argin[2];
        argin[0] = matlabFuncHandle;
        argin[1] = mxCreateDoubleMatrix((mwSize) ndim, (mwSize) 1, mxREAL);
        memcpy(mxGetDoubles(argin[1]), state, ndim * sizeof(double));

        // Get the MATLAB function output arguments.

        mxArray *argout[1];
        mexCallMATLAB(1, argout, 2, argin, "feval");

        // Parse the MATLAB function output arguments.

        double logFunc = mxGetScalar(argout[0]);
        mxDestroyArray(argin[1]);
        return logFunc;
    }
    int32_t runParaDRAM(double(*getLogFunc)(double state[], int32_t ndim), const int32_t ndim, const char* input);
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // prhs: method, getLogFunc, ndim, input.
    if(0 < nlhs) mexErrMsgIdAndTxt("Mex:ParaMonte:maxlhs", "Internal ParaMonte MATLAB library error occurred: Too many output arguments.");
    if (nrhs != 4) {mexErrMsgIdAndTxt("Mex:ParaMonte:invalidNumInputs", "Internal ParaMonte MATLAB library error occurred: input variable mismatch.");}
    mwSize iarg;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    iarg = 0;
    if (mxGetM(prhs[iarg]) != 1) mexErrMsgIdAndTxt("Mex:ParaMonte:inputNotVector", "Input must be a row vector of characters.");
    if (mxIsChar(prhs[iarg]) != 1) mexErrMsgIdAndTxt("Mex:ParaMonte:inputNotString", "Internal ParaMonte MATLAB library error occurred: Input #0 (method) must be a string.");

    char *method;
    method = mxArrayToString(prhs[iarg]);
    if(method == NULL) mexErrMsgIdAndTxt("Mex:ParaMonte:conversionFailed", "Internal ParaMonte MATLAB library error occurred: Could not convert input #0 (method) to string.");

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    iarg = 1;
    if(!mxIsClass(prhs[iarg], "function_handle")) mexErrMsgTxt("The second input argument must be a function handle.");
    matlabFuncHandle = mxDuplicateArray(prhs[iarg]);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    iarg = 2;
    int32_t ndim = mxGetScalar(prhs[iarg]);

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    iarg = 3;
    if (mxIsChar(prhs[iarg]) != 1) mexErrMsgIdAndTxt("Mex:ParaMonte:inputNotString", "Internal ParaMonte MATLAB library error occurred: Input #3 must be a string.");
    if (mxGetM(prhs[iarg]) != 1) mexErrMsgIdAndTxt("Mex:ParaMonte:inputNotVector", "Input must be a row vector.");

    char *input;
    input = mxArrayToString(prhs[iarg]);
    if(input == NULL) mexErrMsgIdAndTxt("Mex:ParaMonte:conversionFailed", "Internal ParaMonte MATLAB library error occurred: Could not convert input #2 to string.");

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    int32_t stat = 0;
    if (strncmp(method, "ParaDRAM", 8) == 0) {
        int32_t njob = mxGetScalar(prhs[3]);
        stat = runParaDRAM(&getLogFunc, ndim, input);
        if (stat != 0) mexErrMsgIdAndTxt("Mex:ParaMonte", "Runtime Error Occurred.");
    } else {
        mexErrMsgIdAndTxt("Mex:ParaMonte:invalidMethod", "Internal ParaMonte MATLAB library error occurred: Invalid input sampling method.");
    }
    mxFree(method);
    mxFree(input);
    return;

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}