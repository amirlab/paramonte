::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::                                                                                                                            ::::
::::    ParaMonte: Parallel Monte Carlo and Machine Learning Library.                                                           ::::
::::                                                                                                                            ::::
::::    Copyright (C) 2012-present, The Computational Data Science Lab                                                          ::::
::::                                                                                                                            ::::
::::    This file is part of the ParaMonte library.                                                                             ::::
::::                                                                                                                            ::::
::::    LICENSE                                                                                                                 ::::
::::                                                                                                                            ::::
::::       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md                                                          ::::
::::                                                                                                                            ::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::
:: See the file install.bat.usage in the same folder for usage guidelines of this Batch script.
::

@echo off
set ERRORLEVEL=0
setlocal EnableDelayedExpansion
set BUILD_SCRIPT_NAME=install.bat
set "script_name=install.bat"
:: change directory to the folder containing this batch file
cd %~dp0

REM WARNING: paramonte_dir ends with a forward slash.

set "paramonte_dir=%~dp0"
set "paramonte_src_dir=!paramonte_dir!src"
set "paramonte_auxil_dir=!paramonte_dir!auxil"
set "paramonte_example_dir=!paramonte_dir!example"
set "paramonte_external_dir=!paramonte_dir!external"
set "paramonte_benchmark_dir=!paramonte_dir!benchmark"
set "paramonte_src_fortran_dir=!paramonte_src_dir!\fortran"
set "paramonte_src_fortran_main_dir=!paramonte_src_fortran_dir!\main"
set "paramonte_src_fortran_test_dir=!paramonte_src_fortran_dir!\test"
set "paramonte_req_dir=!paramonte_external_dir!\prerequisites"

set "paramonte_web_github=https://github.com/cdslaborg/paramonte"
set "paramonte_web_github_issues=!paramonte_web_github!/issues/new/choose"
set "build_name=ParaMontes"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Set up platform.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set os=!OS!
set arch=!PLATFORM!
if !arch!==x64 (
    set arch=amd64
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Set up color coding.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM \warning
REM ESC contains the escape ASCII character.
set "ESC="
set "ColorReset=!ESC![0m"
set "ColorBold=!ESC![1m"
set "Red=!ESC![31m"
set "Green=!ESC![32m"
set "Yellow=!ESC![33m"
set "Blue=!ESC![34m"
set "Magenta=!ESC![35m"
set "Cyan=!ESC![36m"
set "White=!ESC![37m"
set "BoldRed=!ESC![1;31m"
set "BoldGreen=!ESC![1;32m"
set "BoldYellow=!ESC![1;33m"
set "BoldBlue=!ESC![1;34m"
set "BoldMagenta=!ESC![1;35m"
set "BoldCyan=!ESC![1;36m"
set "BoldWhite=!ESC![1;37m"

set "pmcolor=!BoldCyan!"
set "pmattn= !pmcolor!-- !build_name! !script_name! -!ColorReset!"
set "pmnote=!pmattn! !BoldYellow!NOTE:!ColorReset!"
set "pmwarn=!pmattn! !BoldMagenta!WARNING:!ColorReset!"
set "pmfatal=!pmattn! !BoldRed!FATAL ERROR:!ColorReset!"
set "warning=!BoldMagenta!WARNING!ColorReset!"

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Fetch and set the ParaMonte library Fortran version.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set "ParaMonteVersion="

cd "!paramonte_auxil_dir!"
for /f "tokens=*" %%i in ('head.bat 1 "..\VERSION.md"') do set "ParaMonteVersion=%%i"
cd %~dp0

REM uncomment the following conditional block to set the ParaMonte version in the source files via the preprocessor macros.
REM This is, however, not recommended. Generating the include source file is the preferred default method of
REM the ParaMonte version to the binaries. Starting ParaMonte release 1.4.2, this is the default behavior.
REM set "FPP_PARAMONTE_VERSION_FLAG="
REM if defined ParaMonteVersion (
REM     set FPP_PARAMONTE_VERSION_FLAG=/define:PARAMONTE_VERSION='!ParaMonteVersion!'
REM )

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: fetch ParaMonte library Fortran release date
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set dayName=!date:~0,3!
set year=!date:~10,4!
set day=!date:~7,2!

set m=100
for %%m in (Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec) do (
    set /a m+=1
    set month[!m:~-2!]=%%m
)
set monthNow=%date:~3,3%
set monthNow=%monthNow: =%
set monthName=!month[%monthNow%]!
set ParaMonteRelease=!dayName!.!monthName!.!day!.!year!

set SERIAL_ENABLED=true

REM echo.
REM type "!paramonte_auxil_dir!\.paramonte.banner"
REM echo.

echo.
echo. ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo. ::::                                                                                  ::::
echo.                ParaMonte library version !ParaMonteVersion! build on Windows
echo.                                     !ParaMonteRelease!
echo. ::::                                                                                  ::::
echo. ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo.

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: parse arguments
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM type "!paramonte_auxil_dir!\install_usage.txt"

echo.
echo.!pmnote! parsing the command-line arguments...
echo.

set bdir=
set FOR_COARRAY_NUM_IMAGES=3
set "ddir=!paramonte_dir!bin"
set "flag_ddir=-Dddir=!ddir!"

set list_build=
set list_checking=
set list_fc=
set list_lang=
set list_lib=
set list_mem=
set list_par=

set flag_bench=
set flag_benchpp=
set flag_blas=
set flag_codecov=
set flag_cfi=
set flag_deps=
set flag_exam=
set flag_exampp=
set flag_fpp=
set flag_fresh=
set flag_G=
set flag_j=
set flag_lapack=
set flag_matlabdir=
set flag_me=
set flag_mod=
set flag_nproc=
set flag_perfprof=
set flag_pdt=
set flag_purity=
set flag_test=

set flag_ski=
set flag_iki=
set flag_lki=
set flag_cki=
set flag_rki=

echo.
type "!paramonte_auxil_dir!\.paramonte.banner"
echo.

:LABEL_parseArgLoop

if not "%1"=="" (

    echo.!pmnote! processing: %1

    set FLAG=%1
    set VALUE=%2
    REM call :getLowerCase FLAG
    REM call :getLowerCase VALUE

    set FLAG_SUPPORTED=
    set VALUE_SUPPORTED=true

    REM :::::::::
    REM list args
    REM :::::::::

    REM --build

    if "!FLAG!"=="--build" (
        set FLAG_SUPPORTED=true
        set "list_build=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --checking

    if "!FLAG!"=="--checking" (
        set FLAG_SUPPORTED=true
        set "list_checking=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --fc

    if "!FLAG!"=="--fc" (
        set FLAG_SUPPORTED=true
        set "list_fc=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --lang

    if "!FLAG!"=="--lang" (
        set FLAG_SUPPORTED=true
        set "list_lang=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --lib

    if "!FLAG!"=="--lib" (
        set FLAG_SUPPORTED=true
        set "list_lib=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --mem

    if "!FLAG!"=="--mem" (
        set FLAG_SUPPORTED=true
        set "list_mem=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --par

    if "!FLAG!"=="--par" (
        set FLAG_SUPPORTED=true
        set "list_par=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM :::::::::
    REM flag args
    REM :::::::::

    REM --bench

    if "!FLAG!"=="--bench" (
        set FLAG_SUPPORTED=true
        set "flag_bench=-Dbench=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --benchpp

    if "!FLAG!"=="--benchpp" (
        set FLAG_SUPPORTED=true
        set "flag_benchpp=-Dbenchpp=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --blas

    if "!FLAG!"=="--blas" (
        set FLAG_SUPPORTED=true
        set "flag_blas=-Dblas=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --codecov

    if "!FLAG!"=="--codecov" (
        set FLAG_SUPPORTED=true
        set "flag_codecov=-Dcodecov=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --deps

    if "!FLAG!"=="--deps" (
        set FLAG_SUPPORTED=true
        set "flag_deps=-Dblas=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --exam

    if "!FLAG!"=="--exam" (
        set FLAG_SUPPORTED=true
        set "flag_exam=-Dexam=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --exampp

    if "!FLAG!"=="--exampp" (
        set FLAG_SUPPORTED=true
        set "flag_exampp=-Dexampp=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --cfi

    if "!FLAG!"=="--cfi" (
        set FLAG_SUPPORTED=true
        set "flag_cfi=-Dcfi=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --fpp

    if "!FLAG!"=="--fpp" (
        set FLAG_SUPPORTED=true
        set "flag_fpp=-Dfpp=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --fresh

    if "!FLAG!"=="--fresh" (
        set FLAG_SUPPORTED=true
        set "flag_fresh=-Dfresh=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --lapack

    if "!FLAG!"=="--lapack" (
        set FLAG_SUPPORTED=true
        set "flag_lapack=-Dlapack=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --matlabdir

    if "!FLAG!"=="--matlabdir" (
        set FLAG_SUPPORTED=true
        set "flag_matlabdir=-Dmatlabdir=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --me

    if "!FLAG!"=="--me" (
        set FLAG_SUPPORTED=true
        set "flag_me=-Dme=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --mod

    if "!FLAG!"=="--mod" (
        set FLAG_SUPPORTED=true
        set "flag_mod=-Dmod=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --nproc

    if "!FLAG!"=="--nproc" (
        set FLAG_SUPPORTED=true
        set "flag_nproc=-Dnproc=!VALUE!"
        set FOR_COARRAY_NUM_IMAGES=!VALUE!
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --perfprof

    if "!FLAG!"=="--perfprof" (
        set FLAG_SUPPORTED=true
        set "flag_perfprof=-Dperfprof=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --pdt

    if "!FLAG!"=="--pdt" (
        set FLAG_SUPPORTED=true
        set "flag_pdt=-Dpdt=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --purity

    if "!FLAG!"=="--purity" (
        set FLAG_SUPPORTED=true
        set "flag_purity=-Dpurity=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --test

    if "!FLAG!"=="--test" (
        set FLAG_SUPPORTED=true
        set "flag_test=-Dtest=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM ::::::::::::::::::::
    REM flag args: type kind
    REM ::::::::::::::::::::

    REM --ski

    if "!FLAG!"=="--ski" (
        set FLAG_SUPPORTED=true
        set "flag_ski=-Dski=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --iki

    if "!FLAG!"=="--iki" (
        set FLAG_SUPPORTED=true
        set "flag_iki=-Diki=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --lki

    if "!FLAG!"=="--lki" (
        set FLAG_SUPPORTED=true
        set "flag_lki=-Dlki=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --cki

    if "!FLAG!"=="--cki" (
        set FLAG_SUPPORTED=true
        set "flag_cki=-Dcki=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --rki

    if "!FLAG!"=="--rki" (
        set FLAG_SUPPORTED=true
        set "flag_rki=-Drki=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM ::::::::::
    REM other args
    REM ::::::::::

    REM --ddir

    if "!FLAG!"=="--ddir" (
        set FLAG_SUPPORTED=true
        set "flag_ddir=-Dddir=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --bdir

    if "!FLAG!"=="--bdir" (
        set FLAG_SUPPORTED=true
        set "bdir=!VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM --help

    if "!FLAG!"=="--help" (
        set FLAG_SUPPORTED=true
        type "!paramonte_dir!install.bat.md"
        type "!paramonte_dir!install.config.md"
        exit /b 0
    )

    REM -G

    if "!FLAG!"=="-G" (
        set FLAG_SUPPORTED=true
        set "flag_G=-G !VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM -j

    if "!FLAG!"=="-j" (
        set FLAG_SUPPORTED=true
        set "flag_j=-j !VALUE!"
        if "!VALUE!"=="" set "VALUE_SUPPORTED=false"
        if /i "!VALUE:~0,2!"=="--" set "VALUE_SUPPORTED=false"
        shift
    )

    REM
    REM Check for errors.
    REM

    if  defined FLAG_SUPPORTED (
        if !VALUE_SUPPORTED! NEQ true goto LABEL_REPORT_ERR
        if !FLAG_SUPPORTED! NEQ true goto LABEL_REPORT_ERR
    )

    shift
    goto :LABEL_parseArgLoop

)

:LABEL_REPORT_ERR

REM Check flag/value support

if defined FLAG_SUPPORTED (
    if "!FLAG_SUPPORTED!"=="true" (
        if "!VALUE_SUPPORTED!" NEQ "true" (
            echo.
            echo.!pmfatal! The requested input value "!VALUE!" specified
            echo.!pmfatal! with the input flag "!FLAG!" is unsupported.
            goto LABEL_ERR
        )
    ) else (
        echo.
        echo.!pmfatal! The requested input flag "!FLAG!" is unsupported.
        goto LABEL_ERR
    )
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Set the default values for the input command line arguments.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if not defined list_build set list_build=release
if not defined list_checking set list_checking=nocheck
if not defined list_lang set list_lang=fortran
if not defined list_lib set list_lib=shared
if not defined list_mem set list_mem=heap
if not defined list_par set list_par=serial
if not defined flag_j set "flag_j=-j"

REM Set the default Fortran compiler and the `list_fc` flag.

if not defined list_fc (
    for %%C in (ifort ifx gfortran) do (
        echo.!pmnote! Checking for the presence of %%~C Fortran compiler...
        call :mktemp tempfile
        where %%~C > "!tempfile!"
        set /p list_fc=<"!tempfile!"
        if exist "!list_fc!" (
            echo.!pmnote! The %%~C Fortran compiler detected in the environment.
            echo.!pmnote! fc="!list_fc!"
            goto :loopExit
        ) else (
            set list_fc=
        )
    )
)
:loopExit
if not defined list_fc (
    echo.!pmwarn! No compatible Fortran compiler detected in the environment.
    echo.!pmwarn! Proceeding without a guarantee of build success...
    set "list_fc=default"
)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Set CMake default flags.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM delete the prerequisite folder if requested.

set "substring=prereq"
if not "!flag_fresh!" == "" (
    if not "!flag_fresh:!substring!=!"=="!flag_fresh!" (
        if exist "!paramonte_req_dir!" (
            echo.!pmnote! Removing the old prerequisites of the ParaMonte library build at paramonte_req_dir="!paramonte_req_dir!"
            rmdir /S /Q "!paramonte_req_dir!"
        )
    )
)

if not defined flag_G (

    REM Set the default CMake makefile generator.

    set "replacement="
    set cmakeBuildGenerator=

    REM Firstly, search for the CMake makefile generator: make

    if not defined cmakeBuildGenerator (
        echo.!pmnote! Searching for the GNU Make application in the command-line environment...
        set "make_version="
        set "substring=GNU Make"
        for /f "Tokens=* Delims=" %%i in ('make --version') do set make_version=!make_version!%%i
        for /f "delims=" %%S in (^""!substring!=!replacement!"^") do (set "make_version_modified=!make_version:%%~S!")
        if not "!make_version_modified!" == "!make_version!" (
            echo.!pmnote! Setting CMake makefile generator to GNU MinGW Make application...
            set "cmakeBuildGenerator=MinGW Makefiles"
        ) else (
            echo.!pmnote! Failed to detect the GNU Make application in the command-line environment. skipping...
        )
    )

    REM Secondly, search for the CMake makefile generator: mingw32-make

    if defined cmakeBuildGenerator (
        echo.!pmnote! Searching for the GNU Make application in the command-line environment...
        set "make_version="
        set "substring=GNU Make"
        for /f "Tokens=* Delims=" %%i in ('mingw32-make --version') do set make_version=!make_version!%%i
        for /f "delims=" %%S in (^""!substring!=!replacement!"^") do (set "make_version_modified=!make_version:%%~S!")
        if not "!make_version_modified!" == "!make_version!" (
            echo.!pmnote! Setting CMake makefile generator to GNU MinGW Make application...
            set "cmakeBuildGenerator=MinGW Makefiles"
        ) else (
            echo.!pmnote! Failed to detect the GNU MinGW Make application in the command-line environment. skipping...
        )
    )

    REM Thirdly, search for the CMake makefile generator: NMake

    if not defined cmakeBuildGenerator (
        echo.!pmnote! Searching for the Microsoft NMake application in the command-line environment...
        set "make_version="
        set "substring=Microsoft"
        for /f "Tokens=* Delims=" %%i in ('nmake') do set make_version=!make_version!%%i
        for /f "delims=" %%S in (^""!substring!=!replacement!"^") do (set "make_version_modified=!make_version:%%~S!")
        if not "!make_version_modified!" == "!make_version!" (
            echo.!pmnote! Setting CMake makefile generator to Microsoft NMake application...
            set "cmakeBuildGenerator=NMake Makefiles"
        ) else (
            echo.!pmnote! Failed to detect the Microsoft NMake application in the command-line environment. skipping...
        )
    )

    REM Revert to the Windows CMD default if no CMake makefile generator is identified.

    if not defined cmakeBuildGenerator (
        echo.
        echo.!pmwarn! Failed to infer the CMake makefile generator.
        echo.!pmwarn! Procedding with Microsoft NMake as the default makefile generator...
        echo.!pmwarn! The CMake configuration and build may fail.
        set "cmakeBuildGenerator=NMake Makefiles"
    )

    set "flag_G=-G "!cmakeBuildGenerator!""

)

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Build the library for all requested configurations.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM Here we trust the user to assign semi-colon separated items as flag values.

for %%C in ("!list_fc:;=" "!") do (

    REM
    REM Set up the CMake fc flag.
    REM

    set "fc=%%~C"
    set "flag_fc="
    if exist "!fc!" (
        set "fcpath=!fc!"
        set "flag_fc=-Dfc="!fcpath!""
    ) else (
        if not "!fc!"=="default" (
            call :mktemp tempfile
            where "!fc!" > "!tempfile!"
            set /p fcpath=<"!tempfile!"
            if exist "!fcpath!" (
                echo.!pmnote! The !fc! Fortran compiler detected in the environment.
                echo.!pmnote! fc="!fcpath!"
            ) else (
                set "fcpath=!fc!"
            )
            if exist "!fcpath!" (
                set "flag_fc=-Dfc="!fcpath!""
                echo.!pmnote! Fortran compiler path fcpath="!fcpath!"
            ) else (
                echo.!pmwarn! Failed to detect the full path for the specified compiler fc=!fc!
                echo.!pmwarn! Proceeding with the build without guarantee of success...
            )
        )
    )

    REM Get the compiler ID.

    set csid=csid
    set "replacement="
    set "substring=intel"
    set "fcpath_lower=!fcpath!"
    call :getLowerCase fcpath_lower
    set "fcpath_modified=!fcpath_lower:%substring%=!"
    for /f "delims=" %%S in (^""!substring!=!replacement!"^") do (set "fcpath_modified=!fcpath_modified:%%~S!")
    if not "!fcpath_modified!"=="!fcpath_lower!" (
        echo.!pmnote! The Fortran compiler vendor is Intel.
        set csid=intel
    ) else (
        set "substring=gfortran"
        for /f "delims=" %%S in (^""!substring!=!replacement!"^") do (set "fcpath_modified=!fcpath_modified:%%~S!")
        if not "!fcpath_modified!"=="!fcpath_lower!" (
            echo.!pmnote! The Fortran compiler vendor is GNU.
            set csid=gnu
        ) else (
            echo.!pmwarn! "Failed to detect the specified Fortran compiler ID (vendor) from its path "!fcpath!""
            echo.!pmwarn! "Processing with CMake build configuration without guarantee of success..."
        )
    )

    REM Get the compiler version.

    set csvs=csvs
    if not !csid!==csid (
        REM Get unique file name.
        cd "!tmp!"
        set "tempsrc=!tmp!\getCompilerVersion.F90"
        call :mktemp tempout "!tmp!" "getCompilerVersion"
        set "tempexe=!tempout!.exe"
        echo F | xcopy /Y "!paramonte_auxil_dir!\getCompilerVersion.F90" "!tempsrc!"
        "!fcpath!" "!tempsrc!" -o "!tempexe!"
        "!tempexe!" "!tempout!.tmp" || (
            echo.!pmwarn! "Failed to infer the specified Fortran compiler version from executable "!fcpath!""
            echo.!pmwarn! "Processing with CMake build configuration without guarantee of success..."
        )
        cd "!paramonte_auxil_dir!"
        for /f "tokens=*" %%i in ('head.bat 1 "!tempout!.tmp"') do set "csvs=%%~i"
        cd %~dp0
    )

    echo.!pmnote! compiler suite !csid!
    echo.!pmnote! compiler version !csvs!

    for %%G in ("!list_lang:;=" "!") do (

        set "flag_lang=-Dlang=%%~G"

        for %%B in ("!list_build:;=" "!") do (

            set "flag_build=-Dbuild=%%~B"

            for %%L in ("!list_lib:;=" "!") do (

                set "flag_lib=-Dlib=%%~L"

                for %%M in ("!list_mem:;=" "!") do (

                    set "flag_mem=-Dmem=%%~M"

                    for %%P in ("!list_par:;=" "!") do (

                        set "flag_par=-Dpar=%%~P"

                        for %%H in ("!list_checking:;=" "!") do (

                            set "flag_checking=-Dchecking=%%~H"

                            REM
                            REM First, determine the parallelism and MPI library name to be used in build directory.
                            REM

                            if %%~P==mpi (
                                set parname=mpi
                                for /f %%i in ('mpiexec --version') do set mpiexec_version=%%i
                                echo !mpiexec_version! | find "Intel" >nul
                                if errorlevel 0 (
                                    echo.!pmnote! Intel MPI library detected...
                                    set parname=impi
                                ) else (
                                    echo.!pmwarn! Failed to infer the MPI library vendor and version.
                                    echo.!pmwarn! The CMake configuration and library build may fail. skipping...
                                )
                            ) else (
                                if %%~P==omp (
                                    set parname=openmp
                                ) else (
                                    if %%~P==none (
                                        set parname=serial
                                    ) else (
                                        set parname=%%~P
                                    )
                                )
                            )

                            REM
                            REM Set the ParaMonte CMake build directory.
                            REM

                            if not defined bdir (
                                set paramonte_bld_dir=!paramonte_dir!bld\!os!\!arch!\!csid!\!csvs!\%%~B\%%~L\%%~M\!parname!\%%~G\%%~H"
                                if "!flag_perfprof!" == "-Dperfprof=all" set paramonte_bld_dir=!paramonte_bld_dir!\perfprof
                                if "!flag_codecov!" == "-Dcodecov=all" set paramonte_bld_dir=!paramonte_bld_dir!\codecov
                                echo.!pmnote! The ParaMonte library build directory paramonte_bld_dir="!paramonte_bld_dir!"
                            ) else (
                                echo.!pmnote! User-specified library build directory detected bdir="!bdir!"
                                set "paramonte_bld_dir=!bdir!"
                            )

                            REM Make the build directory if needed.

                            if not exist "!paramonte_bld_dir!" (
                                echo.!pmnote! Generating the ParaMonte build directory...
                                mkdir "!paramonte_bld_dir!"
                            )

                            REM
                            REM Configure and build the library via CMake.
                            REM

                            echo.!pmnote! All generated build files will be stored at "!paramonte_bld_dir!"
                            echo.!pmnote! Changing directory to "!paramonte_bld_dir!"
                            echo.
                            echo.****************************************************************************************************
                            echo.
                            echo.!pmnote! Invoking CMake as:
                            echo.

                            @echo on
                            cd "!paramonte_bld_dir!"
                            REM cmake "!paramonte_dir!" !flag_g! ""!cmakeBuildGenerator!"" "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON" !flag_ddir! ^
                            cmake !paramonte_dir! !flag_G! -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON !flag_build! !flag_checking! !flag_lib! !flag_mem! !flag_par! !flag_fc! ^
                            !flag_ddir! !flag_bench! !flag_benchpp! !flag_blas! !flag_codecov! !flag_cfi! !flag_deps! !flag_exam! !flag_exampp! !flag_fpp! !flag_fresh! !flag_lapack! !flag_matlabdir! ^
                            !flag_lang! !flag_me! !flag_mod! !flag_nproc! !flag_perfprof! !flag_pdt! !flag_purity! !flag_test! !flag_ski! !flag_iki! !flag_lki! !flag_cki! !flag_rki! ^
                            && (
                                @echo off
                                echo.
                                echo.!pmnote! !BoldGreen!ParaMonte configuration with CMake appears to have succeeded.!ColorReset!
                            ) || (
                                @echo off
                                echo.
                                echo.!pmfatal! !BoldRed!ParaMonte configuration with CMake appears to have failed.!ColorReset!
                                goto LABEL_ERR
                            )
                            echo.
                            echo.****************************************************************************************************
                            echo.

                            cd "!paramonte_bld_dir!" && cmake --build "!paramonte_bld_dir!" !flag_j! && (
                                echo.
                                echo.!pmnote! !BoldGreen!ParaMonte build appears to have succeeded.!ColorReset!
                                echo.
                            ) || (
                                echo.
                                echo.!pmnote! !BoldRed!ParaMonte build appears to have failed.!ColorReset!
                                echo.
                                goto LABEL_ERR
                            )

                            cd "!paramonte_bld_dir!" && cmake --build "!paramonte_bld_dir!" --target install !flag_j! && (
                                echo.
                                echo.!pmnote! !BoldGreen!ParaMonte installation appears to have succeeded.!ColorReset!
                                echo.
                            ) || (
                                echo.
                                echo.!pmnote! !BoldRed!ParaMonte installation appears to have failed.!ColorReset!
                                echo.
                                goto LABEL_ERR
                            )

                            cd "!paramonte_bld_dir!" && cmake --build "!paramonte_bld_dir!" --target deploy !flag_j! && (
                                echo.
                                echo.!pmnote! !BoldGreen!ParaMonte deploy appears to have succeeded.!ColorReset!
                                echo.
                            ) || (
                                echo.
                                echo.!pmnote! !BoldRed!ParaMonte deploy appears to have failed.!ColorReset!
                                echo.
                                goto LABEL_ERR
                            )

                            cd "!paramonte_bld_dir!" && cmake --build "!paramonte_bld_dir!" --target test && (
                                echo.
                                echo.!pmnote! !BoldGreen!ParaMonte test appears to have succeeded.!ColorReset!
                                echo.
                            ) || (
                                echo.
                                echo.!pmnote! !BoldRed!ParaMonte test appears to have failed.!ColorReset!
                                echo.
                                goto LABEL_ERR
                            )

                            cd "!paramonte_bld_dir!" && cmake --build "!paramonte_bld_dir!" --target example && (
                                echo.
                                echo.!pmnote! !BoldGreen!ParaMonte example appears to have succeeded.!ColorReset!
                                echo.
                            ) || (
                                echo.
                                echo.!pmnote! !BoldRed!ParaMonte example appears to have failed.!ColorReset!
                                echo.
                                goto LABEL_ERR
                            )

                            cd "!paramonte_bld_dir!" && cmake --build "!paramonte_bld_dir!" --target benchmark && (
                                echo.
                                echo.!pmnote! !BoldGreen!ParaMonte benchmark appears to have succeeded.!ColorReset!
                                echo.
                            ) || (
                                echo.
                                echo.!pmnote! !BoldRed!ParaMonte benchmark appears to have failed.!ColorReset!
                                echo.
                                goto LABEL_ERR
                            )

                            echo.
                            echo.!pmnote! !BoldGreen!All build files for the current build configurations are stored at!ColorReset! "!paramonte_bld_dir!"
                            echo.

                        )
                    )
                )
            )
        )
    )
)

echo.
echo.!pmnote! !BoldGreen!All build files for all requested build configurations are stored at!ColorReset! "!paramonte_dir!bld"
echo.!pmnote! !BoldGreen!The installed binary files for all requested build configurations are ready to use at!ColorReset! "!ddir!"
echo.

goto LABEL_EOF

:: subroutines

:mktemp
REM Get unique random file name: mktemp tempfile mktemp_dir prefix suffix
REM where tempfile is the output and mktemp_dir and prefix and suffix are three optional input arguments.
if "%~2" == "" (
    set mktemp_dir=!tmp!
) else (
    set "mktemp_dir=%~2"
)
:loopUniq
set "%1=!mktemp_dir!\%~3!RANDOM!%~4"
if exist "%~3" goto :loopUniq
GOTO:EOF

:getLowerCase
:: Subroutine to convert a variable VALUE to all lower case.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("/=/" "+=+" "A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF

:getUpperCase
:: Subroutine to convert a variable VALUE to all UPPER CASE.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("/=/" "+=+" "a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF

:getTitleCase
:: Subroutine to convert a variable VALUE to Title Case.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("/=/" "+=+" " a= A" " b= B" " c= C" " d= D" " e= E" " f= F" " g= G" " h= H" " i= I" " j= J" " k= K" " l= L" " m= M" " n= N" " o= O" " p= P" " q= Q" " r= R" " s= S" " t= T" " u= U" " v= V" " w= W" " x= X" " y= Y" " z= Z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF

:LABEL_ERR

echo.
echo.!pmnote! To see the list of possible flags and associated values, try:
echo.!pmnote!
echo.!pmnote!     install.bat --help
echo.!pmnote!
echo.!pmnote! gracefully exiting the !script_name! script.
echo.

exit /B 1

:LABEL_copyErrorOccured

echo.
echo.!pmfatal! Failed to copy contents. exiting...
echo.
cd %~dp0
set ERRORLEVEL=1
exit /B 1

:LABEL_delErrorOccured

echo.
echo.!pmfatal! Failed to delete contents. exiting...
echo.
cd %~dp0
set ERRORLEVEL=1
exit /B 1

:LABEL_EOF

echo.
echo.!pmnote! !BoldGreen!mission accomplished.!ColorReset!
echo.

exit /B 0
