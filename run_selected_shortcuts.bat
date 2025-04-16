@echo off
setlocal

if "%~1"=="" (
    echo ショートカットをこのバッチにドラッグ＆ドロップしてください。
    pause
    exit /b
)

:loop
if "%~1"=="" goto :end
start "" "%~1"
shift
goto loop

:end
exit