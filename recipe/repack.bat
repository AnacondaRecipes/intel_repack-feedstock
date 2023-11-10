echo "Building %PKG_NAME%."
set "src=%SRC_DIR%\%PKG_NAME%"

@REM @REM The license files are no longer manually packed but are included via the meta.yaml
@REM if exist %src%\info\LICENSE.txt (
@REM     COPY %src%\info\LICENSE.txt %SRC_DIR%
@REM ) else (
@REM     COPY %SRC_DIR%\mkl\info\licenses\license.txt %SRC_DIR%
@REM )

robocopy /E "%src%" "%PREFIX%"
if %ERRORLEVEL% GEQ 8 exit 1

:: Remove info coming from conda package. conda-build will provide its own metadata.
rd /s /q %PREFIX%\info

if "%PKG_NAME%"=="intel-openmp" (
    echo "Generating libiomp5md.lib"
    :: If in the fiture Intel decies to ship the import library, error out.
    :: If this happens, please remove this hack.
    if exist %LIBRARY_PREFIX%\lib\libiomp5md.lib exit 1

    :: Create the import library for libiomp5md.dll. Intel unfortunately doesn't provide it.
    cd %LIBRARY_PREFIX%\bin
    :: Note that both CMake's FindMKL and Pytorch's own FindMKL modules want and expect
    :: "libiomp5md.dll", not "libiomp5md_dll.dll"!
    :: The same can be said about the MKLConfig cmake file provided by mkl-devel.
    %RECIPE_DIR%\dll2lib.bat 64 libiomp5md.dll
    if %ERRORLEVEL% GEQ 1 exit 1

    dir %LIBRARY_PREFIX%
    dir %LIBRARY_PREFIX%\lib
    if not exist %LIBRARY_PREFIX%\lib\libiomp5md.lib exit 1
)
