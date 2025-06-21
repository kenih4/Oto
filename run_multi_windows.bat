@echo off
setlocal enabledelayedexpansion

set "x=0"
set "y=0"
set "offset=300"

rem テスト用ショートカット
set "test1=C:\Users\kenic\OneDrive\Desktop\testBL1.lnk"
set "test2=C:\Users\kenic\OneDrive\Desktop\testBL2.lnk"
set "test3=C:\Users\kenic\OneDrive\Desktop\testBL3.lnk"

if "%~1"=="" (
    echo テスト用ショートカットを起動します...
    call :launch "%test1%"
    call :launch "%test2%"
    call :launch "%test3%"
    goto :end
)

:loop
if "%~1"=="" goto :end
call :launch "%~1"
shift
goto loop

:launch
set "file=%~1"
if !x! gtr 1000 (
    set x=0
    set /a y+=%offset%
)
echo %x% %y%
powershell -ExecutionPolicy Bypass -File "%~dp0launch_windows.ps1" -shortcut "%file%" -x !x! -y !y!
set /a x+=%offset%
exit /b

:end
exit