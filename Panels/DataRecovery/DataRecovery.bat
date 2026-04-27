@echo off

:: ============================================================
:: Elevate to admin (Verbose)
:: ============================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

setlocal enabledelayedexpansion
goto main

:: ============================================================
:: Timestamp (Pure batch, locale-safe)
:: Format: DD-MM-YYYY_HH-MM-SS
:: ============================================================
:maketimestamp
setlocal enabledelayedexpansion

set "raw=%date% %time%"
set "digits="

for /l %%I in (0,1,31) do (
    set "ch=!raw:~%%I,1!"
    for %%D in (0 1 2 3 4 5 6 7 8 9) do (
        if "!ch!"=="%%D" set "digits=!digits!!ch!"
    )
)

set "DD=!digits:~0,2!"
set "MM=!digits:~2,2!"
set "YYYY=!digits:~4,4!"
set "HH=!digits:~8,2!"
set "NN=!digits:~10,2!"
set "SS=!digits:~12,2!"

if "!HH:~0,1!"==" " set "HH=0!HH:~1,1!"

set "timestamp=!DD!-!MM!-!YYYY!_!HH!-!NN!-!SS!"
set "timestamp_readable=!DD!-!MM!-!YYYY! !HH!:!NN!:!SS!"

endlocal & set "timestamp=%timestamp%" & set "timestamp_readable=%timestamp_readable%"
goto :eof

:: ============================================================
:: Convert bytes to human-readable
:: ============================================================
:convert_bytes
set bytes_raw=%1
set bytes_hr=%bytes_raw%
if %bytes_raw% LSS 1024 set bytes_hr=%bytes_raw% B&goto :eof
set /a kb=%bytes_raw%/1024
if %kb% LSS 1024 set bytes_hr=%kb% KB&goto :eof
set /a mb=%kb%/1024
if %mb% LSS 1024 set bytes_hr=%mb% MB&goto :eof
set /a gb=%mb%/1024
set bytes_hr=%gb% GB
goto :eof

:: ============================================================
:: Parse robocopy summary
:: ============================================================
:parse_summary
set "log=%~1"

for /f "tokens=2,3,4,5,6,7" %%a in ('findstr /C:"Dirs :" "%log%"') do (
    set dirs_total=%%a
    set dirs_copied=%%b
    set dirs_skipped=%%c
    set dirs_failed=%%e
)

for /f "tokens=2,3,4,5,6,7" %%a in ('findstr /C:"Files :" "%log%"') do (
    set files_total=%%a
    set files_copied=%%b
    set files_skipped=%%c
    set files_failed=%%e
)

for /f "tokens=2,3" %%a in ('findstr /C:"Bytes :" "%log%"') do (
    set bytes_total_raw=%%a
    set bytes_copied_raw=%%b
)

call :convert_bytes %bytes_total_raw%
set bytes_total=%bytes_hr%
call :convert_bytes %bytes_copied_raw%
set bytes_copied=%bytes_hr%

for /f "tokens=2" %%a in ('findstr /C:"Times :" "%log%"') do set time_elapsed=%%a
goto :eof

:: ============================================================
:: Build destination root
:: ============================================================
:build_dest
if "%destDrive%"=="" (
    echo ERROR: Destination drive required.
    pause
    set "destRoot="
    goto :eof
)
set "destRoot=%destDrive%:\WDRT_Recovery"
if not exist "%destRoot%" mkdir "%destRoot%" >nul 2>&1
goto :eof

:: ============================================================
:: MAIN MENU
:: ============================================================
:main
cls
echo.
echo ============================
echo       Data Recovery
echo ============================
echo.
echo 1.) Full Disk Recovery
echo 2.) User Folder Recovery
echo 3.) Media Recovery
echo 4.) BitLocker Status / Unlock
echo.
echo 0.) Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" goto fulldisk
if "%choice%"=="2" goto userfolders
if "%choice%"=="3" goto media
if "%choice%"=="4" goto bitlocker
if "%choice%"=="0" goto end
goto main

:: ============================================================
:: FULL DISK RECOVERY
:: ============================================================
:fulldisk
cls
echo --- Full Disk Recovery ---
echo.
set /p srcDrive=Enter source drive letter: 
if "%srcDrive%"=="" goto main

echo.
echo Include AppData?
echo 1.) Yes
echo 2.) Roaming Only
echo 3.) No
set /p appdataChoice=

echo.
set /p destDrive=Enter destination drive letter: 
call :build_dest
if "%destRoot%"=="" goto fulldisk

if /I "%srcDrive%"=="%destDrive%" (
    echo ERROR: Source and destination cannot match.
    pause
    goto fulldisk
)

set "destSub=%destRoot%\FullDisk"
if not exist "%destSub%" mkdir "%destSub%" >nul 2>&1

call :maketimestamp
set "log=%destRoot%\FullDisk_%timestamp%.log"

set "RC_EXCLUDE=/XD %destRoot% %destSub%"
if "%appdataChoice%"=="3" set "RC_EXCLUDE=%RC_EXCLUDE% AppData Local LocalLow Roaming"

robocopy "%srcDrive%:\" "%destSub%" /E /R:1 /W:1 %RC_EXCLUDE% > "%log%"

call :parse_summary "%log%"

cls
echo ===== Recovery Summary =====
echo Source: %srcDrive%:\
echo Destination: %destSub%
echo Directories: %dirs_total% total, %dirs_copied% copied
echo Files: %files_total% total, %files_copied% copied
echo Bytes: %bytes_total% total, %bytes_copied% copied
echo Time: %time_elapsed%
echo Skipped: %files_skipped%
echo Failed: %files_failed%
echo Generated: %timestamp_readable%

pause
goto main

:: ============================================================
:: USER FOLDER RECOVERY
:: ============================================================
:userfolders
cls
echo --- User Folder Recovery ---
echo.
set /p srcDrive=Enter source drive letter: 
if "%srcDrive%"=="" goto main

echo.
echo Include AppData?
echo 1.) Yes
echo 2.) Roaming Only
echo 3.) No
set /p appdataChoice=

echo.
set /p destDrive=Enter destination drive letter: 
call :build_dest
if "%destRoot%"=="" goto userfolders

if /I "%srcDrive%"=="%destDrive%" (
    echo ERROR: Source and destination cannot match.
    pause
    goto userfolders
)

set "destSub=%destRoot%\UserFolders"
if not exist "%destSub%" mkdir "%destSub%" >nul 2>&1

call :maketimestamp
set "log=%destRoot%\UserFolders_%timestamp%.log"

for /d %%U in ("%srcDrive%:\Users\*") do (
    set "user=%%~nU"
    for /d %%F in ("%%U\*") do (
        set "folder=%%~nxF"
        set "skip=0"

        if /I "!folder!"=="AppData" (
            if "%appdataChoice%"=="1" robocopy "%%F" "%destSub%\!user!\AppData" /E /R:1 /W:1 >> "%log%"
            if "%appdataChoice%"=="2" if exist "%%F\Roaming" robocopy "%%F\Roaming" "%destSub%\!user!\AppData\Roaming" /E /R:1 /W:1 >> "%log%"
            set "skip=1"
        )

        fsutil reparsepoint query "%%F" >nul 2>&1
        if !errorlevel! EQU 0 set "skip=1"

        if "!skip!"=="0" robocopy "%%F" "%destSub%\!user!\!folder!" /E /R:1 /W:1 >> "%log%"
    )
)

call :parse_summary "%log%"

cls
echo ===== Recovery Summary =====
echo Source: %srcDrive%:\
echo Destination: %destSub%
echo Directories: %dirs_total% total, %dirs_copied% copied
echo Files: %files_total% total, %files_copied% copied
echo Bytes: %bytes_total% total, %bytes_copied% copied
echo Time: %time_elapsed%
echo Skipped: %files_skipped%
echo Failed: %files_failed%
echo Generated: %timestamp_readable%

pause
goto main

:: ============================================================
:: MEDIA RECOVERY
:: ============================================================
:media
cls
echo --- Media Recovery ---
echo.
set /p srcDrive=Enter source drive letter: 
if "%srcDrive%"=="" goto main

echo.
echo Include AppData?
echo 1.) Yes
echo 2.) No
set /p appdataChoice=

echo.
set /p destDrive=Enter destination drive letter: 
call :build_dest
if "%destRoot%"=="" goto media

if /I "%srcDrive%"=="%destDrive%" (
    echo ERROR: Source and destination cannot match.
    pause
    goto media
)

set "destSub=%destRoot%\Media"
if not exist "%destSub%" mkdir "%destSub%" >nul 2>&1

call :maketimestamp
set "log=%destRoot%\Media_%timestamp%.log"

set "RC_EXCLUDE=/XD %destRoot% %destSub%"
if "%appdataChoice%"=="2" set "RC_EXCLUDE=%RC_EXCLUDE% AppData Local LocalLow Roaming"

robocopy "%srcDrive%:\" "%destSub%" *.jpg *.jpeg *.png *.gif *.bmp *.tif *.tiff *.heic *.webp *.cr2 *.nef *.arw *.rw2 *.orf *.dng *.mp4 *.mov *.avi *.mkv *.wmv *.3gp *.m4v *.mp3 *.wav *.flac *.aac *.ogg *.opus *.m4a /S /R:1 /W:1 %RC_EXCLUDE% /LOG+:"%log%"

call :parse_summary "%log%"

cls
echo ===== Recovery Summary =====
echo Source: %srcDrive%:\
echo Destination: %destSub%
echo Directories: %dirs_total% total, %dirs_copied% copied
echo Files: %files_total% total, %files_copied% copied
echo Bytes: %bytes_total% total, %bytes_copied% copied
echo Time: %time_elapsed%
echo Skipped: %files_skipped%
echo Failed: %files_failed%
echo Generated: %timestamp_readable%

pause
goto main

:: ============================================================
:: BITLOCKER
:: ============================================================
:bitlocker
cls
echo --- BitLocker Status / Unlock ---
echo.
set /p srcDrive=Enter drive letter: 
if "%srcDrive%"=="" goto main

manage-bde -status %srcDrive%:
echo.
set /p key=Enter recovery key (or press ENTER to skip): 
if not "%key%"=="" manage-bde -unlock %srcDrive%: -RecoveryPassword %key%
pause
goto main

:end
endlocal
exit /b
