@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    pause
    exit /b
)

set "wt_cmd=wt"
set i=0

:loop
if "%~1"=="" goto run

rem lnk からターゲットと引数を取得
set "exe="
set "args="

for /f "usebackq tokens=*" %%A in (`powershell -nologo -noprofile -command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%~1');      Write-Output $s.TargetPath; Write-Output $s.Arguments"`) do (
    if not defined exe (
        set "exe=%%A"
    ) else (
        set "args=%%A"
    )
)

rem ダブルクオート付きでexeを包む。argsはそのまま。
set "quotedExe=\"!exe!\""

if !i! EQU 0 (
    set "wt_cmd=!wt_cmd! split-pane -p PowerShell --title "%~n1" --commandline !quotedExe! !args!"
) else (
    set "wt_cmd=!wt_cmd! ; split-pane -p PowerShell --title "%~n1" --commandline !quotedExe! !args! --vertical"
)

set /a i+=1
shift
goto loop

:run
echo ----------------------------------------
echo [DEBUG] 実行コマンド:
echo !wt_cmd!
echo ----------------------------------------
pause
%wt_cmd%
