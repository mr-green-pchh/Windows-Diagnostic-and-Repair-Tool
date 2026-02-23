@echo off
set "APP_VERSION=1.2.3"
title WDRT v%APP_VERSION%


:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
echo.
echo WDRT v%APP_VERSION% requires administrator privileges to run properly.
echo close the program, right click the file and run it in administrator mode.
echo.
pause
exit /b
)


:: Terms and Conditions
:terms
cls
echo.
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
echo.
echo.
echo  1.) I agree to these terms and conditions.
echo  0.) Exit
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto menu
if "%choice%"=="0" goto end
echo Invalid selection.
pause
goto terms



:: Main Menu
:menu
cls
echo.
echo  ============================
echo            WDRT v%APP_VERSION%
echo  ============================
echo.
echo.
echo  1.) System
echo  2.) Account
echo  3.) Network
echo  4.) Devices
echo  5.) License
echo.
echo  0.) Exit
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto system
if "%choice%"=="2" goto account
if "%choice%"=="3" goto network
if "%choice%"=="4" goto devices
if "%choice%"=="5" goto license
if "%choice%"=="0" goto end
echo Invalid selection.
pause
goto menu


::System Section
:system
cls
echo.
echo  ============================
echo         System Section
echo  ============================
echo.
echo.
echo  1.) System Information
echo  2.) Services
echo  3.) Task Manager
echo  4.) Export Minidumps
echo  5.) Repair
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto sysinfo
if "%choice%"=="2" goto services
if "%choice%"=="3" goto taskmanager
if "%choice%"=="4" goto getdumps
if "%choice%"=="5" goto systemrepairconfirm
if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto system





:: Account Section
:account
cls
echo.
echo  ============================
echo         Account Section
echo  ============================
echo.
echo  This section is not available yet.
echo  Try again later!
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



::Network Section
:network
cls
echo.
echo  ============================
echo         Network Section
echo  ============================
echo.
echo  This section is not available yet.
echo  Try again later!
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




::Devices Section
:devices
cls
echo.
echo  ============================
echo         Devices Section
echo  ============================
echo.
echo  This section is not available yet.
echo  Try again later!
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


:: License
:license
cls
echo.
echo MIT License
echo.
echo Copyright (c) 2026 Repair My Computer
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo.
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
echo.
echo.
echo  0.) Go back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto license

::Launch Services
:services
cls
start services.msc
goto system

::Launch Task Manager
:taskmanager
cls
start taskmgr.exe
goto system



::Developer Section
:developer
cls
echo.
echo  ============================
echo         Developer Section
echo  ============================
echo.
echo  Developed by repairmycomputer.net
echo.
echo.
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="0" goto menu
echo Invalid selection.
pause
goto developer

::System Repair Confirmation Screen
:systemrepairconfirm
cls
echo.
echo Are you sure you want to run the system repair?
echo This can take several minutes to complete.
echo.
echo.
echo  1.) Yes
echo  0.) Go Back
echo.
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto systemrepair
if "%choice%"=="0" goto system
echo Invalid selection.
pause
goto systemrepairconfirm

::System Repair Command Line
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

:: Reports back errors during the SFC Command
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

:: Reports back errors during the DISM Command 
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


:: Fetch Minidump Command
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




