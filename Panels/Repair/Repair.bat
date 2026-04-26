@echo off
cls
echo.
echo  ============================
echo         Repair Tools
echo  ============================
echo.
echo  1.) Run System Repair (SFC + DISM)
echo  0.) Go Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto runrepair
if "%choice%"=="0" exit /b

echo Invalid selection.
pause
exit /b

:runrepair
cls
echo Running SFC and DISM...
echo This may take several minutes.
echo.

sfc /scannow
if %errorlevel% neq 0 goto sfc_error

DISM /Online /Cleanup-Image /RestoreHealth
if %errorlevel% neq 0 goto dism_error

sfc /scannow
pause
exit /b

:sfc_error
echo SFC encountered an error.
echo Error code: %errorlevel%
pause
exit /b

:dism_error
echo DISM encountered an error.
echo Error code: %errorlevel%
pause
exit /b
