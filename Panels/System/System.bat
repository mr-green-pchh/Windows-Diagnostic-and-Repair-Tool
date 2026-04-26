@echo off
cls
echo.
echo  ============================
echo         System Section
echo  ============================
echo.
echo  1.) System Information
echo  2.) Services
echo  3.) Task Manager
echo  4.) Export Minidumps
echo  5.) Repair Tools
echo.
echo  0.) Go Back
echo.
set /p choice=Select an option: 

if "%choice%"=="1" start msinfo32.exe & exit /b
if "%choice%"=="2" start services.msc & exit /b
if "%choice%"=="3" start taskmgr.exe & exit /b
if "%choice%"=="4" call "%ROOT%Panels\System\GetDumps.bat" & exit /b
if "%choice%"=="5" call "%ROOT%Panels\Repair\Repair.bat"
if "%choice%"=="0" exit /b

echo Invalid selection.
pause
exit /b
