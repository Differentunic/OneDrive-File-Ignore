@echo off

REM This program will create a new loacl policy that prevents OneDrive from uploading folder names, and file extentions that are defined in the OneDrive.ignore file.

REM OneDrive Policy template loaction:
REM %localappdata%\Microsoft\OneDrive\<version>\adm

REM Windows Management Instrumentation Command-line (WMIC) template:
REM wmic datafile where name="<executable path>" get Version /value

REM Download command line Group Policy Management Tools
DISM.exe /Online /add-capability /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0

REM OneDrive path
set OneDrive-Path=%localappdata%\Microsoft\OneDrive

REM OneDrive Executable Path (double slash for wmic)
set OneDrive-wmic-Path=%OneDrive-Path%\Onedrive.exe
set OneDrive-wmic-Path=%OneDrive-wmic-Path:\=\\%
echo %OneDrive-wmic-Path%

echo OneDrive-Path=%OneDrive-Path%
set OneDrive-Version=0

REM Get the output of wmic and assign it to a variable
for /f %%a in ('wmic datafile where "name="%OneDrive-wmic-Path%"" get Version /value ^| find "="') do set OneDrive-Version=%%a

REM Remove the 'Version=' string from the variable
set OneDrive-Version=%OneDrive-Version:~8%
set OneDrive-Version-Temp=%OneDrive-Version:~11%
set OneDrive-Version-Full=%OneDrive-Version:~0,11%


REM calculate length to determine how many zero characters need to be added
call :strlen result OneDrive-Version-Temp
echo %result%

set /a Padding = 4 - %result%
echo %Padding%

REM Add zero padding (if applicable)
set loop=0
:loop
set OneDrive-Version-Full=%OneDrive-Version-Full%0
set /a loop=%loop%+1
if "%loop%"=="%padding%" goto next
goto loop

:next
REM Bring original number back into the full version number
set OneDrive-Version-Full=%OneDrive-Version-Full%%OneDrive-Version-Temp%
echo OneDrive-Version-Full=%OneDrive-Version-Full%

dir %OneDrive-Path% /b REM | find /i "%OneDrive-Version-Full%"


REM Go to end of file so that the function does not run when not called.
goto :eof

:strlen <resultVar> <stringVar>
(
    setlocal EnableDelayedExpansion
    (set^ tmp=!%~2!)
    if defined tmp (
        set "len=1"
        for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
            if "!tmp:~%%P,1!" NEQ "" (
                set /a "len+=%%P"
                set "tmp=!tmp:~%%P!"
            )
        )
    ) ELSE (
        set len=0
    )
)
(
    endlocal
    set "%~1=%len%"
    exit /b
)

