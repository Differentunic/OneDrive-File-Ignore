@echo off

setlocal
call :setESC
cls

set GitHub-Repo-Url=https://github.com/Differentunic/OneDrive-File-Ignore

REM This program will create a new loacl policy that prevents OneDrive from uploading folder names, and file extentions that are defined in the OneDrive.ignore file.

REM OneDrive Policy template loaction:
REM %localappdata%\Microsoft\OneDrive\<version>\adm

REM Windows Management Instrumentation Command-line (WMIC) template:
REM wmic datafile where name="<executable path>" get Version /value

REM Download command line Group Policy Management Tools
DISM.exe /Online /add-capability /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0

REM OneDrive path
set OneDrive-Path=%localappdata%\Microsoft\OneDrive
if exist %OneDrive-Path%\ (
    echo %ESC%[92mOneDrive Installation Found.%ESC%[0m
    echo.
) else (
    echo %ESC%[91mOneDrive Installation Not Found.%ESC%[0m
    echo.
    echo Is OneDrive installed?
    echo Please check the OneDrive install directory: %OneDrive-Path%
    echo.
    echo If you believe that something is wrong with this tool, please open an issue on GitHub.
    echo %ESC%[36m%ESC%[4m%GitHub-Repo-Url%%ESC%[0m%ESC%[0m
    pause
    REM exit 3
    goto :eof
)

echo You can find your OneDrive Version
set /P OneDrive-Version-Full=OneDrive Version Number: || Set OneDrive-Version-Full=Null
If "%OneDrive-Version-Full%"=="Null" goto sub_error
echo OneDrive-Version-Full=%OneDrive-Version-Full%

REM dir %OneDrive-Path% /b | find /i "%OneDrive-Version-Full%"

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)
exit /B 0