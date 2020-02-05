#**********************************************************************************************************************************
#**********************************************************************************************************************************
#
#  ParaMonte: plain powerful parallel Monte Carlo library.
#
#  Copyright (C) 2012-present, The Computational Data Science Lab
#
#  This file is part of ParaMonte library. 
#
#  ParaMonte is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation, version 3 of the License.
#
#  ParaMonte is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with ParaMonte.  If not, see <https://www.gnu.org/licenses/>.
#
#**********************************************************************************************************************************
#**********************************************************************************************************************************

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Fortran compiler/linker debug build flags. Will be used only when build mode is set to debug
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if (WIN32)
    set(INTEL_Fortran_DEBUG_FLAGS 
    /debug:full 
    /Zi 
    /CB 
    /Od 
    /Qinit:snan,arrays 
    /warn:all 
    /gen-interfaces 
    /traceback 
    /check:all 
    /check:bounds 
    /fpe-all:0 
    /Qdiag-error-limit:10 
    /Qdiag-disable:5268 
    /Qdiag-disable:7025 
    /Qtrapuv
    )
    unset(GNU_Fortran_DEBUG_FLAGS)
else()
    set(INTEL_Fortran_DEBUG_FLAGS 
    -debug full               # generate full debug information
    -g3                       # generate full debug information
    -O0                       # disable optimizations
    -CB                       # Perform run-time bound-checks on array subscript and substring references (same as the -check bounds option)
    -init:snan,arrays         # initialize arrays and scalars to NaN
    -warn all                 # enable all warning
    -gen-interfaces           # generate interface block for each routine in the source files
    -traceback                # trace back for debugging
    -check all                # check all
    -check bounds             # check array bounds
    -fpe-all=0                # Floating-point invalid, divide-by-zero, and overflow exceptions are enabled
    -diag-error-limit=10      # max diagnostic error count
    -diag-disable=5268        # Extension to standard: The text exceeds right hand column allowed on the line.
    -diag-disable=7025        # This directive is not standard Fxx.
    -diag-disable=10346       # optimization reporting will be enabled at link time when performing interprocedural optimizations.
    -ftrapuv                  # Initializes stack local variables to an unusual value to aid error detection.
    )
    set(GNU_Fortran_DEBUG_FLAGS 
    -g                                    # generate full debug information
    -O0                                   # disable optimizations
    -fcheck=all                           # enable the generation of run-time checks
    -ffpe-trap=zero,overflow,underflow    # Floating-point invalid, divide-by-zero, and overflow exceptions are enabled
    -finit-real=snan                      # initialize REAL and COMPLEX variables with a signaling NaN
    -fbacktrace                           # trace back for debugging
    --pedantic                            # issue warnings for uses of extensions to the Fortran standard
    -fmax-errors=10                       # max diagnostic error count
    -Wall                                 # enable all warnings: 
                                          # -Waliasing, -Wampersand, -Wconversion, -Wsurprising, -Wc-binding-type, -Wintrinsics-std, -Wtabs, -Wintrinsic-shadow,
                                          # -Wline-truncation, -Wtarget-lifetime, -Winteger-division, -Wreal-q-constant, -Wunused, -Wundefined-do-loop
    )
endif()
if (DEFINED INTEL_Fortran_DEBUG_FLAGS)
    set(INTEL_Fortran_DEBUG_FLAGS "${INTEL_Fortran_DEBUG_FLAGS}" CACHE STRING "Intel Fortran compiler/linker debug build flags" FORCE)
endif()
if (DEFINED GNU_Fortran_DEBUG_FLAGS)
    set(GNU_Fortran_DEBUG_FLAGS "${GNU_Fortran_DEBUG_FLAGS}" CACHE STRING "GNU Fortran compiler/linker debug build flags" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Intel Fortran compiler/linker release build flags. Will be used only when compiler is intel and build mode is set to release
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# /Qipo-c generates a single object file, containing all object files.
# INTEL_Fortran_RELEASE_FLAGS=/fast /O3 /Qip /Qipo /Qunroll /Qunroll-aggressive /inline:all /Ob2 /Qparallel /Qinline-dllimport

if(WIN32)
    set(INTEL_Fortran_RELEASE_FLAGS
    /O3                       # set the optimizations level
    /Qip                      # determines whether additional interprocedural optimizations for single-file compilation are enabled.
    /Qipo                     # enable interprocedural optimization between files.
    /Qunroll                  # [:n] set the maximum number of times to unroll loops (no number n means automatic).
    /Qunroll-aggressive       # use more aggressive unrolling for certain loops.
    /Qvec                     # enable vectorization.
    )
else()
    set(INTEL_Fortran_RELEASE_FLAGS
    -O3                       # set the optimizations level
    -ip                       # determines whether additional interprocedural optimizations for single-file compilation are enabled.
   #-ipo                      # enable interprocedural optimization between files.
    -unroll                   # [=n] set the maximum number of times to unroll loops (no number n means automatic).
    -unroll-aggressive        # use more aggressive unrolling for certain loops.
    -finline-functions        # enables function inlining for single file compilation.
    -diag-disable=10346       # optimization reporting will be enabled at link time when performing interprocedural optimizations.
    -diag-disable=10397       # optimization reporting will be enabled at link time when performing interprocedural optimizations.
    #-vec                      # enable vectorization.
    )
    set(GNU_Fortran_RELEASE_FLAGS "${GNU_Fortran_RELEASE_FLAGS}"
    #-static-libgfortran -static-libgcc 
    -O3                       # set the optimizations level
   #-flto                     # enable interprocedural optimization between files.
    -funroll-loops            # [=n] set the maximum number of times to unroll loops (no number n means automatic).
    -finline-functions        # consider all functions for inlining, even if they are not declared inline.
    -ftree-vectorize          # perform vectorization on trees. enables -ftree-loop-vectorize and -ftree-slp-vectorize. 
    )
endif()
if (DEFINED INTEL_Fortran_RELEASE_FLAGS)
    set(INTEL_Fortran_RELEASE_FLAGS "${INTEL_Fortran_RELEASE_FLAGS}" CACHE STRING "Intel Fortran compiler/linker release build flags" FORCE)
endif()
if (DEFINED GNU_Fortran_RELEASE_FLAGS)
    set(GNU_Fortran_RELEASE_FLAGS "${GNU_Fortran_RELEASE_FLAGS}" CACHE STRING "GNU Fortran compiler/linker release build flags" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Intel Fortran compiler/linker testing build flags. Will be used only when compiler is intel and build mode is set to testing
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if(WIN32)
    set(INTEL_Fortran_TESTING_FLAGS 
    /Od  # disable optimization
    )
    unset(GNU_Fortran_TESTING_FLAGS)
else()
    set(INTEL_Fortran_TESTING_FLAGS 
    -O0  # disable optimization
    )
    set(GNU_Fortran_TESTING_FLAGS 
    #-static-libgfortran -static-libgcc 
    -O0  # disable optimization
    )
endif()
if (DEFINED INTEL_Fortran_TESTING_FLAGS)
    set(INTEL_Fortran_TESTING_FLAGS "${INTEL_Fortran_TESTING_FLAGS}" CACHE STRING "Intel Fortran compiler/linker testing build flags" FORCE)
endif()
if (DEFINED GNU_Fortran_TESTING_FLAGS)
    set(GNU_Fortran_TESTING_FLAGS "${GNU_Fortran_TESTING_FLAGS}" CACHE STRING "GNU Fortran compiler/linker testing build flags" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Intel Fortran compiler preprocessor definitions.
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# Will be used to pass any user-defined macro definition to the intel compiler for preprocessing the files.
# A macro is denoted by /define:MACRO_NAME=VALUE, the value of which can be dropped, and if so, it will be given a default value of 1.
# Example: /define:INTEL, will create a macro INTEL with a default value of 1.
# set( INTEL_Fortran_PREPROCESSOR_MACROS "" CACHE STRING "Intel Fortran compiler preprocessor definitions" )

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Intel C++ compiler/linker debug build flags. Will be used only when compiler is intel and build mode is set to Debug
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if(WIN32)
    set(INTEL_CXX_DEBUG_FLAGS 
    /debug:full 
    /Zi 
    /Od 
    /Wall 
    /traceback 
    /Qcheck-pointers:rw                   # check bounds for memory access through pointers.
    /Qcheck-pointers-undimensioned        # check bounds for memory access through arrays that are declared without dimensions.
    /Qdiag-error-limit:10 
    /Qtrapuv 
    )
else()
    set(INTEL_CXX_DEBUG_FLAGS 
    -debug full 
    -g3 
    -O0 
    -Wall 
    -traceback 
    -check-pointers=rw                    # check bounds for memory access through pointers.
    -check-pointers-undimensioned         # check bounds for memory access through arrays that are declared without dimensions.
    -diag-error-limit=10 
    -ftrapuv 
    )
    set(GNU_CXX_DEBUG_FLAGS 
    #-static-libgfortran -static-libgcc 
    -g                                    # generate full debug information
    -O0                                   # disable optimizations
    -fcheck=all                           # enable the generation of run-time checks
    -ffpe-trap=zero,overflow,underflow    # Floating-point invalid, divide-by-zero, and overflow exceptions are enabled
    -finit-real=snan                      # initialize REAL and COMPLEX variables with a signaling NaN
    -fbacktrace                           # trace back for debugging
    --pedantic                            # issue warnings for uses of extensions to the Fortran standard
    -fmax-errors=10                       # max diagnostic error count
    -Wall                                 # enable all warnings: 
                                          # -Waliasing, -Wampersand, -Wconversion, -Wsurprising, -Wc-binding-type, -Wintrinsics-std, -Wtabs, -Wintrinsic-shadow,
                                          # -Wline-truncation, -Wtarget-lifetime, -Winteger-division, -Wreal-q-constant, -Wunused, -Wundefined-do-loop
    )
endif()
if (DEFINED INTEL_CXX_DEBUG_FLAGS)
    set(INTEL_CXX_DEBUG_FLAGS "${INTEL_CXX_DEBUG_FLAGS}" CACHE STRING "Intel C/C++ compiler/linker debug build flags" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Intel Fortran compiler/linker release build flags. Will be used only when compiler is intel and build mode is set to Release
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if(WIN32)
    set(INTEL_CXX_RELEASE_FLAGS 
    /O3 
    /Qip 
    /Qipo 
    /Qunroll 
    /Qunroll-aggressive 
    /Ob2 
    /Qinline-dllimport 
    # /Qparallel  # Tells the auto-parallelizer to generate multithreaded code for loops that can be safely executed in parallel.
    )
else()
    set(INTEL_CXX_RELEASE_FLAGS 
    -O3 
    -ip 
    -ipo 
    -unroll 
    -unroll-aggressive 
    -inline-level=2 
    # -parallel   # Tells the auto-parallelizer to generate multithreaded code for loops that can be safely executed in parallel.
    )
    set(GNU_CXX_RELEASE_FLAGS 
    -O3                       # set the optimizations level
    -flto                     # enable interprocedural optimization between files.
    -funroll-loops            # [=n] set the maximum number of times to unroll loops (no number n means automatic).
    -finline-functions        # consider all functions for inlining, even if they are not declared inline.
    -ftree-vectorize          # perform vectorization on trees. enables -ftree-loop-vectorize and -ftree-slp-vectorize. 
    )
endif()
if (DEFINED INTEL_CXX_RELEASE_FLAGS)
    set(INTEL_CXX_RELEASE_FLAGS "${INTEL_CXX_RELEASE_FLAGS}" CACHE STRING "Intel C/C++ compiler/linker release build flags" FORCE)
endif()
if (DEFINED GNU_CXX_RELEASE_FLAGS)
    set(GNU_CXX_RELEASE_FLAGS "${GNU_CXX_RELEASE_FLAGS}" CACHE STRING "GNU C/C++ compiler/linker release build flags" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Intel C++ compiler/linker testing build flags. Will be used only when compiler is intel and build mode is set to testing/RelWithDebInfo.
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if(WIN32)
    if (intel_compiler)
        set(INTEL_CXX_TESTING_FLAGS 
        /Od
        )
    endif()
else()
    if (intel_compiler)
        set(INTEL_CXX_TESTING_FLAGS 
        -O0
        )
    elseif(gnu_compiler)
        set(GNU_CXX_TESTING_FLAGS 
        -O0
        )
    endif()
endif()
if (DEFINED INTEL_CXX_TESTING_FLAGS)
    set(INTEL_CXX_TESTING_FLAGS "${INTEL_CXX_TESTING_FLAGS}" CACHE STRING "Intel C/C++ compiler/linker testing build flags" FORCE)
endif()
if (DEFINED GNU_CXX_TESTING_FLAGS)
    set(GNU_CXX_TESTING_FLAGS "${GNU_CXX_TESTING_FLAGS}" CACHE STRING "GNU C/C++ compiler/linker testing build flags" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# set path to the Python interpreter
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set( Python_PATH "" CACHE STRING "Path to the Python interpreter" )

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# set interoperability mode preprocessor's flag (FPP_CFI_FLAG)
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if (CFI_ENABLED)
    set( FPP_CFI_FLAG -DCFI_ENABLED  CACHE STRING "Path to the Python interpreter" )
    #add_definitions(${FPP_CFI_FLAG})
else()
    set( FPP_CFI_FLAG  CACHE STRING "Path to the Python interpreter" )
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# report build spec and setup flags
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# OS = CMAKE_SYSTEM_NAME
#message( STATUS "${pmattn} operating system / platform: ${CMAKE_SYSTEM_NAME} / ${ARCHITECTURE_ID}" )
message( STATUS "${pmattn} operating system / platform: ${CMAKE_SYSTEM_NAME} / ${CMAKE_SYSTEM_PROCESSOR}" )
message( STATUS "${pmattn} compiler suite/version: ${CMAKE_Fortran_COMPILER_ID} / ${CMAKE_Fortran_COMPILER_VERSION}" )
message( STATUS "${pmattn} CFI_ENABLED=${CFI_ENABLED}" )
message( STATUS "${pmattn} TEST_RUN_ENABLED=${ParaMonteTest_RUN_ENABLED}" )
message( STATUS "${pmattn} build type: ${CMAKE_BUILD_TYPE}" )
message( STATUS "${pmattn} link type: ${LTYPE}" )

# set shared library Fortran linker flags
if (${LTYPE} MATCHES "[Dd][Yy][Nn][Aa][Mm][Ii][Cc]")

    if (gnu_compiler)

        set(FC_LIB_FLAGS 
            -fPIC -shared 
            CACHE STRING "GNU Fortran compiler dynamic library flags" )

        set(FL_LIB_FLAGS 
            -fPIC -shared -Wl,-rpath=.
            CACHE STRING "GNU Fortran linker dynamic library flags" )

    else(intel_compiler)

        if (APPLE)
            set(FC_LIB_FLAGS 
                -fpic -dynamiclib -arch_only i386 -noall_load -weak_references_mismatches non-weak # -threads"
                CACHE STRING "Intel Mac Fortran compiler dynamic library flags" )
            set(FL_LIB_FLAGS
                -shared -dynamiclib -arch_only i386 -noall_load -weak_references_mismatches non-weak -Wl,-rpath,. # -threads"
                CACHE STRING "Intel Apple Fortran linker dynamic library flags" )
                # https://software.intel.com/en-us/fortran-compiler-developer-guide-and-reference-creating-shared-libraries
        elseif(WIN32)
            set(FC_LIB_FLAGS 
                /libs:dll #/threads " # these flags are actually included by default in recent ifort implementations
                CACHE STRING "Intel Windows Fortran compiler dynamic library flags" )
            set(FL_LIB_FLAGS
                /dll 
                CACHE STRING "Intel Fortran linker dynamic library flags" )
        elseif(UNIX AND NOT APPLE)
            set(LINUX TRUE)
            set(FC_LIB_FLAGS 
                -fpic -shared #-threads -fast -static-intel # -fpic: Request compiler to generate position-independent code.
                CACHE STRING "Intel Linux Fortran compiler dynamic library flags" )
            set(FL_LIB_FLAGS
                -shared -Wl,-rpath,. #-threads -fast -static-intel
                CACHE STRING "Intel Linux Fortran linker dynamic library flags" )
        endif()
    endif()

    unset(FPP_DLL_FLAGS)
    if (DLL_ENABLED)
        set( FPP_DLL_FLAGS -DDLL_ENABLED )
    endif()
    set(FPP_DLL_FLAGS "${FPP_DLL_FLAGS}" CACHE STRING "Fortran preprocessor dynamic library definitions" )

endif()
message( STATUS "${pmattn} dynamic-library build compiler flags: ${FC_LIB_FLAGS}" )
message( STATUS "${pmattn} dynamic-library build linker flags: ${FL_LIB_FLAGS}" )

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#: set preprocessor build flags
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if (CMAKE_BUILD_TYPE MATCHES "Debug|DEBUG|debug")
    set(FPP_BUILD_FLAGS 
        -DDBG_ENABLED 
        CACHE STRING "ParaMonete build preprocessor flags" FORCE)
else()
    set(FPP_BUILD_FLAGS 
        ""
        CACHE STRING "ParaMonete build preprocessor flags" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#: set default C/CPP/Fortran compilers/linkers
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if (intel_compiler)
    set(FPP_FCL_FLAGS 
        -DIFORT_ENABLED 
        CACHE STRING "compiler-specific preprocessor definitions" FORCE)
else(gnu_compiler)
    set(FPP_FCL_FLAGS 
        -DGNU_ENABLED 
        CACHE STRING "compiler-specific preprocessor definitions" FORCE)
endif()

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#: set up preprocessor flags
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# to save the intermediate files via ifort: FPP /Qsave_temps <original file> <intermediate file>
if (intel_compiler)
    set( FPP_FLAGS -fpp )
elseif (gnu_compiler)
    set( FPP_FLAGS -cpp )
endif()
set(FPP_FLAGS 
    "${FPP_FLAGS}" "${FPP_CFI_FLAG}" "${FPP_BUILD_FLAGS}" "${FPP_FCL_FLAGS}" "${FPP_DLL_FLAGS}" "${USER_PREPROCESSOR_MACROS}"
    CACHE STRING "Fortran compiler preprocessor flags" FORCE )
#add_definitions(${FPP_FLAGS})

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#: set up coarray flags
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

message( STATUS "${pmattn} setting up Coarray Fortran (CAF) parallelization model. Options: single, shared, distributed" )
message( STATUS "${pmattn} requested CAF: ${CAFTYPE}" )

if( "${CAFTYPE}" STREQUAL "single" OR
    "${CAFTYPE}" STREQUAL "shared" OR
    "${CAFTYPE}" STREQUAL "distributed" )
    set(FPP_FLAGS "${FPP_FLAGS}" -DCAF_ENABLED )
    message( STATUS "${pmattn} enabling Coarray Fortran syntax via preprocesor flag -DCAF_ENABLED" )
    set(CAF_ENABLED ON CACHE BOOL "Enable Coarray Fortran parallelism" FORCE)
    if (intel_compiler)
        set(CAF_FLAGS -coarray=${CAFTYPE} CACHE STRING "Coarray Fortran parallelism compiler flags" FORCE)
        set(FOR_COARRAY_NUM_IMAGES 3 CACHE STRING "The default number of coarray images/processes")
    else()
        #set(CAF_FLAGS -fcoarray=${CAFTYPE} CACHE STRING "Coarray Fortran parallelism compiler flags" FORCE)
        set(FOR_COARRAY_NUM_IMAGES 3 CACHE STRING "The default number of coarray images/processes")
    endif()
else()
    message( STATUS "${pmattn} ignoring Coarray Fortran parallelization." )
    set(CAF_ENABLED OFF CACHE BOOL "Coarray Fortran parallelism" FORCE)
    set(CAF_FLAGS "" CACHE STRING "Coarray Fortran parallelism compiler flags" FORCE) # xx
endif()

message( STATUS "${pmattn} Coarray Fortran flags: ${CAF_FLAGS}" )

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#: set non-coarray parallelization flags and definitions to be passed to the preprocessors
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if (MPI_ENABLED)
    if (intel_compiler)
        #if (${LTYPE} MATCHES "[Dd][Yy][Nn][Aa][Mm][Ii][Cc]")
        #    set(MPI_Fortran_COMPILER_FLAGS -static_mpi "MPI parallelism compiler flags")
        #endif()
        #set(MPI_FLAGS CACHE STRING "MPI parallelism compiler flags") # -static_mpi 
    else()
        set(MPI_FLAGS CACHE STRING "MPI parallelism compiler flags")
    endif()
    if (CAF_ENABLED)
        message (FATAL_ERROR
                " \n"
                "${pmfatal}\n"
                "   Coarray Fortran cannot be mixed with MPI.\n"
                "   CAFTYPE: ${CAFTYPE}\n"
                "   MPI_ENABLED: ${MPI_ENABLED}\n"
                "   set MPI_ENABLED and CAFTYPE to appropriate values in the ParaMonte CMAKE CACHE file and rebuild.\n"
                )
    else()
        set(FPP_FLAGS "${FPP_FLAGS}" -DMPI_ENABLED )
    endif()
else()
    set(MPI_FLAGS " " CACHE STRING "MPI parallelism compiler flags")
endif()

if (OMP_ENABLED)
    if (intel_compiler)
        if(WIN32)
            set(OMP_FLAGS /Qopenmp  CACHE STRING "OpenMP parallelism compiler flags")
        else()
            set(OMP_FLAGS -qopenmp  CACHE STRING "OpenMP parallelism compiler flags")
        endif()
    elseif (gnu_compiler)
        set(OMP_FLAGS -fopenmp  CACHE STRING "OpenMP parallelism compiler flags")
    endif()
else()
    set(OMP_FLAGS  CACHE STRING "OpenMP parallelism compiler flags")
endif()

unset(FCL_PARALLELIZATION_FLAGS)
if (CAF_ENABLED)
    message( STATUS "${pmattn} CAF flags: ${CAF_FLAGS}" )
    set(FCL_PARALLELIZATION_FLAGS "${CAF_FLAGS}")
endif()
if (MPI_ENABLED)
    message( STATUS "${pmattn} MPI flags: ${MPI_FLAGS}" )
    set(FCL_PARALLELIZATION_FLAGS "${MPI_FLAGS}")
endif()
if (OMP_ENABLED)
    message( STATUS "${pmattn} OMP flags: ${OMP_FLAGS}" )
    set(FCL_PARALLELIZATION_FLAGS "${OMP_FLAGS}")
endif()
if (DEFINED FCL_PARALLELIZATION_FLAGS)
    set(FCL_PARALLELIZATION_FLAGS "${FCL_PARALLELIZATION_FLAGS}" CACHE STRING "compiler parallelization flags" FORCE)
endif()
message( STATUS "${pmattn} compiler/linker parallelization flags: ${FCL_PARALLELIZATION_FLAGS}" )

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#: set set default Fortran compiler flags in different build modes.
#: Complete list of intel compiler options:
#: https://software.intel.com/en-us/Fortran-compiler-developer-guide-and-reference-alphabetical-list-of-compiler-options
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

option(MT_ENABLED "Enabled multithreaded library linking" ON)

if (intel_compiler)

    # /QxHost
    if (WIN32)
        set(FCL_FLAGS_DEFAULT
        /nologo               # no logo
        /standard-semantics   # determines whether the current Fortran Standard behavior of the compiler is fully implemented.
        /F0x1000000000        # specify the stack reserve amount for the program.
        )
        if (MT_ENABLED)
            set(FCL_FLAGS_DEFAULT "${FCL_FLAGS_DEFAULT}" /threads )
        endif()
    else()
        set(FCL_FLAGS_DEFAULT
        -static-intel 
        -nologo               # no logo
        -standard-semantics   # determines whether the current Fortran Standard behavior of the compiler is fully implemented.
        )
        if (MT_ENABLED)
            set(FCL_FLAGS_DEFAULT "${FCL_FLAGS_DEFAULT}" -threads )
        endif()
    endif()

    if (CMAKE_BUILD_TYPE MATCHES "Debug|DEBUG|debug")
        if (WIN32)
            set(FCL_BUILD_FLAGS
            "${INTEL_Fortran_DEBUG_FLAGS}"
            /stand:f08  # issue compile-time messages for nonstandard language elements.
            )
            set(CCL_BUILD_FLAGS
            "${INTEL_CXX_DEBUG_FLAGS}"
            )
        else()
            set(FCL_BUILD_FLAGS
            "${INTEL_Fortran_DEBUG_FLAGS}"
            -stand f08  # issue compile-time messages for nonstandard language elements.
            )
            set(CCL_BUILD_FLAGS
            "${INTEL_CXX_DEBUG_FLAGS}"
            )
        endif()
    elseif (CMAKE_BUILD_TYPE MATCHES "Release|RELEASE|release")
        if (WIN32)
            set(FCL_BUILD_FLAGS
            "${INTEL_Fortran_RELEASE_FLAGS}"
            /Qopt-report:2 
            )
            set(CCL_BUILD_FLAGS
            "${INTEL_CXX_RELEASE_FLAGS}"
            )
            set(FL_FLAGS /Qopt-report:2 ) # set Fortran linker flags for release mode
        else()
            set(FCL_BUILD_FLAGS
            "${INTEL_Fortran_RELEASE_FLAGS}"
            -qopt-report=2 
            )
            set(CCL_BUILD_FLAGS
            "${INTEL_CXX_RELEASE_FLAGS}"
            )
            set(FL_FLAGS -qopt-report=2 ) # set Fortran linker flags for release mode
        endif()
        #/Qipo-c:
        #   Tells the compiler to optimize across multiple files and generate a single object file ipo_out.obj without linking
        #   info at: https://software.intel.com/en-us/Fortran-compiler-developer-guide-and-reference-ipo-c-qipo-c
    #elseif (CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo|RELWITHDEBINFO|relwithdebinfo")
    elseif (CMAKE_BUILD_TYPE MATCHES "testing|TESTING")
        set(FCL_BUILD_FLAGS "${INTEL_Fortran_TESTING_FLAGS}" )
        set(CCL_BUILD_FLAGS "${INTEL_CXX_TESTING_FLAGS}" )
    endif()

elseif (gnu_compiler)

    set(FCL_FLAGS_DEFAULT -std=gnu -ffree-line-length-none  CACHE STRING "GNU Fortran default compiler flags" )
    set(CCL_FLAGS_DEFAULT -ffree-line-length-none  CACHE STRING "GNU CXX default compiler flags" )
    if (MT_ENABLED)
        set(FCL_FLAGS_DEFAULT "${FCL_FLAGS_DEFAULT}" -pthread )
        set(CCL_FLAGS_DEFAULT "${CCL_FLAGS_DEFAULT}" -pthread )
    endif()

    set(FL_FLAGS -fopt-info-all=GFortranOptReport.txt ) # set Fortran linker flags for release mode

    if (CMAKE_BUILD_TYPE MATCHES "Debug|DEBUG|debug")
        set(FCL_BUILD_FLAGS "${GNU_Fortran_DEBUG_FLAGS}")
        set(CCL_BUILD_FLAGS "${GNU_CXX_DEBUG_FLAGS}")
    elseif (CMAKE_BUILD_TYPE MATCHES "Release|RELEASE|release")
        set(FCL_BUILD_FLAGS "${GNU_Fortran_RELEASE_FLAGS}")
        set(CCL_BUILD_FLAGS "${GNU_CXX_RELEASE_FLAGS}")
    #elseif (CMAKE_BUILD_TYPE MATCHES "RelWithDebInfo|RELWITHDEBINFO|relwithdebinfo")
    elseif (CMAKE_BUILD_TYPE MATCHES "testing|TESTING")
        set(FCL_BUILD_FLAGS "${GNU_Fortran_TESTING_FLAGS}")
        set(CCL_BUILD_FLAGS "${GNU_CXX_TESTING_FLAGS}")
    endif()

endif()

set(FCL_FLAGS_DEFAULT "${FCL_FLAGS_DEFAULT}" CACHE STRING "Fortran default compiler flags" FORCE)
set(CCL_FLAGS_DEFAULT "${CCL_FLAGS_DEFAULT}" CACHE STRING "CXX default compiler flags" FORCE)
set(FCL_FLAGS "${FCL_FLAGS_DEFAULT}" "${FCL_PARALLELIZATION_FLAGS}" "${FCL_BUILD_FLAGS}" )
set(CCL_FLAGS "${CCL_FLAGS_DEFAULT}" "${CCL_BUILD_FLAGS}" )

if (HEAP_ARRAY_ENABLED)
    if (intel_compiler)
        if (WIN32)
            set(FCL_FLAGS "${FCL_FLAGS}" /heap-arrays:10 )
        else()
            set(FCL_FLAGS "${FCL_FLAGS}" -heap-arrays=10 )
        endif()
    elseif(gnu_compiler)
        set(FCL_FLAGS "${FCL_FLAGS}" -fmax-stack-var-size=10 )
    endif()
endif()

message( STATUS "${pmattn} C/C++ compiler/linker flags in ${CMAKE_BUILD_TYPE} build mode: ${CCL_BUILD_FLAGS}" )
message( STATUS "${pmattn} C/C++ compiler/linker default flags: ${CCL_FLAGS_DEFAULT}" )
message( STATUS "${pmattn} C/C++ compiler/linker flags: ${CCL_FLAGS}" )

message( STATUS "${pmattn} Fortran compiler/linker flags in ${CMAKE_BUILD_TYPE} build mode: " "${FCL_BUILD_FLAGS}" )
message( STATUS "${pmattn} Fortran compiler/linker default flags: " "${FCL_FLAGS_DEFAULT}" )
message( STATUS "${pmattn} Fortran compiler/linker dynamic library flags: " "${FC_LIB_FLAGS}" )
message( STATUS "${pmattn} Fortran compiler/linker flags: " "${FCL_FLAGS}" )
message( STATUS "${pmattn} Fortran linker flags: " "${FL_FLAGS}" )
message( STATUS "${pmattn} Fortran preprocessor flags: " "${FPP_FLAGS}" )

#set(CMAKE_C_FLAGS ${CCL_FLAGS} CACHE STRING "C compiler/linker flags" FORCE)
#set(CMAKE_CXX_FLAGS ${CCL_FLAGS} CACHE STRING "C++ compiler/linker flags" FORCE)
#set(CMAKE_Fortran_FLAGS ${FCL_FLAGS}${FC_LIB_FLAGS}${FPP_FLAGS} CACHE STRING "Fortran compiler/linker flags" FORCE)
unset(CMAKE_Fortran_FLAGS)
set(CMAKE_Fortran_FLAGS "${FPP_FLAGS}" CACHE STRING "Fortran compiler/linker flags" FORCE)
string(REPLACE ";" " " CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS}")
#set(CMAKE_EXE_LINKER_FLAGS ${FL_FLAGS}${FCL_FLAGS}${FL_LIB_FLAGS} CACHE STRING "Fortran compiler/linker flags" FORCE)
message( STATUS "${pmattn} CMAKE_C_FLAGS:       ${CMAKE_C_FLAGS}")
message( STATUS "${pmattn} CMAKE_CXX_FLAGS:     ${CMAKE_CXX_FLAGS}")
message( STATUS "${pmattn} CMAKE_Fortran_FLAGS: ${CMAKE_Fortran_FLAGS}")
