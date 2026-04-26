@echo off
cls
set dumpPath=C:\Windows\Minidump
set desktop=%USERPROFILE%\Desktop

if not exist "%dumpPath%" (
    echo Minidump directory does not exist.
    pause
    exit /b
)

echo Creating ZIP of minidump files...
set zipFile=%desktop%\Minidumps.zip

powershell -command "Compress-Archive -Path '%dumpPath%\*' -DestinationPath '%zipFile%' -Force"

echo.
echo ZIP created at:
echo %zipFile%
echo.
pause
exit /b
