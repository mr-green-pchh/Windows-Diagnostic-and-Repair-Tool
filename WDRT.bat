@echo off
set "APP_VERSION=1.3.1"
set "ROOT=%~dp0"
title WDRT v%APP_VERSION%

:: --- Auto-elevate to Administrator ---
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs" 2>nul
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
echo  1.) I agree to these terms and conditions.
echo  0.) Exit
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
echo  1.) System
echo  2.) Account
echo  3.) Network
echo  4.) Devices
echo  5.) License
echo.
echo  0.) Exit
echo.
set /p choice=Select an option: 

if "%choice%"=="1" call "%ROOT%Panels\System\System.bat" & goto menu
if "%choice%"=="2" call "%ROOT%Panels\Account\Account.bat" & goto menu
if "%choice%"=="3" call "%ROOT%Panels\Network\Network.bat" & goto menu
if "%choice%"=="4" call "%ROOT%Panels\Devices\Devices.bat" & goto menu
if "%choice%"=="5" call "%ROOT%Panels\License\License.bat" & goto menu


if "%choice%"=="0" goto end

echo Invalid selection.
pause
goto menu

:end
echo Exiting...
exit
