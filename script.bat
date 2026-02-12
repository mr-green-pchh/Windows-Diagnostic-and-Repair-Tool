@echo off
title Windows Diagnostic and Repair Tool v1.1

:menu
cls
echo ===========================================
echo   Windows Diagnostic and Repair Tool v1.1
echo ===========================================
echo.
echo       1 - Fetch Minidump Files
echo       2 - System Information
echo       3 - Account Settings
echo       4 - Developer Information
echo       0 - Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto getdumps
if "%choice%"=="2" goto sysinfo
if "%choice%"=="3" goto menu2
if "%choice%"=="4" goto devinfo
if "%choice%"=="0" goto end
echo Invalid selection.
pause
goto menu


:menu2
cls
echo ===============================
echo        System Tools Menu
echo ===============================
echo 1) Account Information
echo 2) Advanced Account Settings
echo 0) Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto accinfo
if "%choice%"=="2" goto accadvinfo
if "%choice%"=="0" goto end
echo Invalid selection.
pause
goto menu



:getdumps
cls
set dumpPath=C:\Windows\Minidump
set desktop=%USERPROFILE%\Desktop

if not exist "%dumpPath%" (
    echo Minidump directory does not exist.
    echo.
    pause
    goto menu
)

echo Creating ZIP of minidump files...

set zipFile=%desktop%\Minidumps.zip

powershell -command "Compress-Archive -Path '%dumpPath%\*' -DestinationPath '%zipFile%' -Force"

echo.
echo ZIP created at:
echo %zipFile%
echo.
pause
goto menu



:devinfo
cls
start "" https://github.com/mr-green-pchh

echo.
goto menu



:sysinfo
cls
start "" "C:\Windows\System32\msinfo32.exe"

echo.
goto menu


:accinfo
cls
start ms-settings:yourinfo

echo.
goto menu

:accadvinfo
cls
start "" "C:\Windows\System32\netplwiz.exe"
echo.
goto menu



:end
echo Exiting...
exit
