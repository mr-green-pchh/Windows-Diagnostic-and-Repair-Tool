@echo off
title WDRT v1.2

:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
echo.
echo WDRT requires administrator privileges to run properly.
echo close the program, right click the file and run it in administrator mode.
echo.
pause
exit /b
)


:menu
cls
echo.
echo  ============================
echo            WDRT v1.2
echo  ============================
echo.
echo.
echo  1.) System
echo  2.) Account
echo  3.) Network
echo  4.) Devices
echo  5.) Services
echo  6.) Developer
echo.
echo  0.) Exit
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto system
if "%choice%"=="2" goto account
if "%choice%"=="3" goto network
if "%choice%"=="4" goto devices
if "%choice%"=="5" goto services
if "%choice%"=="6" goto developer
if "%choice%"=="0" goto end
echo Invalid selection.
pause
goto menu


:system
cls
echo.
echo  ============================
echo         System Section
echo  ============================
echo.
echo.
echo  1.) System Information
echo  2.) Export Minidump
echo  3.) Repair
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto sysinfo
if "%choice%"=="2" goto getdumps
if "%choice%"=="3" goto systemrepair
if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto system






:account
cls
echo.
echo  ============================
echo         Account Section
echo  ============================
echo.
echo.
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto account




:network
cls
echo.
echo  ============================
echo         Network Section
echo  ============================
echo.
echo.
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto network





:devices
cls
echo.
echo  ============================
echo         Devices Section
echo  ============================
echo.
echo.
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto devices





:services
cls
echo.
echo  ============================
echo         Services Section
echo  ============================
echo.
echo.
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto services




:developer
cls
echo.
echo  ============================
echo         Developer Section
echo  ============================
echo.
echo.
echo  Developed by repairmycomputer.net
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto developer




:systemrepair
cls

echo Running SFC...
sfc /scannow
if %errorlevel% neq 0 goto sfc_error
echo.
echo SFC Repair Completed.
echo.

echo Running DISM...
DISM /Online /Cleanup-Image /RestoreHealth
if %errorlevel% neq 0 goto dism_error
echo.
echo DISM Repair Completed.
echo.
echo All System Repairs Have Been Completed.
echo.
pause
goto system


:sfc_error
echo.
echo SFC encountered an error.
echo Error code: %errorlevel%
echo.
echo  1.) Go Back
echo  0.) Exit
set /p choice=Select an option: 
if "%choice%"=="1" goto system
exit /b


:dism_error
echo.
echo DISM encountered an error.
echo Error code: %errorlevel%
echo.
echo  1.) Go Back
echo  0.) Exit
set /p choice=Select an option: 
if "%choice%"=="1" goto system
exit /b



:getdumps
cls
set dumpPath=C:\Windows\Minidump
set desktop=%USERPROFILE%\Desktop

if not exist "%dumpPath%" (
    echo Minidump directory does not exist.
    echo.
    pause
    goto system
)

echo Creating ZIP of minidump files...

set zipFile=%desktop%\Minidumps.zip

powershell -command "Compress-Archive -Path '%dumpPath%\*' -DestinationPath '%zipFile%' -Force"

echo.
echo ZIP created at:
echo %zipFile%
echo.
pause
goto system



:devinfo
cls
start "" https://github.com/mr-green-pchh

echo.
goto menu



:sysinfo
cls
start "" "C:\Windows\System32\msinfo32.exe"

echo.
goto system


:accinfo
cls
start ms-settings:yourinfo

echo.
goto menu2

:accadvinfo
cls
start "" "C:\Windows\System32\netplwiz.exe"
echo.
goto menu2



:end
echo Exiting...
exit
