set "src=%SRC_DIR%\%PKG_NAME%"
COPY "%src%\info\licenses\LICENSE.txt" "%SRC_DIR%"

COPY %RECIPE_DIR%\site.cfg %PREFIX%\site.cfg
unix2dos %PREFIX%\site.cfg
echo library_dirs = %LIBRARY_LIB%  >> %PREFIX%\site.cfg
echo include_dirs = %LIBRARY_INC%  >> %PREFIX%\site.cfg

robocopy /E "%src%" "%PREFIX%"
if %ERRORLEVEL% GEQ 8 exit 1

:: correct .pc files that point to intel64 lib dir instead of just lib
sed -i.bak -E "s|libdir=(.*)/intel64|libdir=\1|g" %PREFIX%\Library\lib\pkgconfig\*.pc
del "%PREFIX%\Library\lib\pkgconfig\*.pc.bak"

:: replace old info folder with our new regenerated one
rd /s /q %PREFIX%\info
