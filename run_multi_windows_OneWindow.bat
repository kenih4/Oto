@echo off
setlocal enabledelayedexpansion

if "%~1"=="" (
    echo 使用方法：
    echo   - Perl スクリプトのショートカット（.lnk）をこのバッチにドラッグ＆ドロップ
    echo   - または、ターミナルから .lnk ファイルを引数にして実行
    echo.
    echo 例： ./run_multi_windows_OneWindow.bat "C:\Users\kenic\OneDrive\Desktop\testBL1.lnk" "C:\Users\kenic\OneDrive\Desktop\testBL2.lnk"
    pause
    exit /b
)

set "wt_cmd=wt --maximized"

:loop
if "%~1"=="" goto run

rem Get .lnk target and arguments using PowerShell
for /f "usebackq tokens=*" %%A in (`powershell -nologo -noprofile -command "$s = (New-Object -ComObject WScript.Shell).CreateShortcut('%~1');  Write-Output $s.TargetPath; Write-Output $s.Arguments"`) do (
    if not defined exe (
        set "exe=%%A"
    ) else (
        set "args=%%A"
        set "wt_cmd=!wt_cmd! nt -p PowerShell --title "%~n1" --commandline ""!exe! !args! "" ;"
rem        set "wt_cmd=!wt_cmd! split-pane --horizontal nt -p PowerShell --title "%~n1" --commandline ""!exe! !args! "" ;"
        set "exe="
    )
    echo "~~~~~~~~"
    echo !wt_cmd!
    echo "~~~~~~~~"
)

shift
goto loop

:run
rem Remove trailing semicolon if present
if "!wt_cmd:~-1!"==";" set "wt_cmd=!wt_cmd:~0,-1!"

echo ----------------------------------------
echo 実行されるコマンド:
echo !wt_cmd!
echo ----------------------------------------
timeout 3

%wt_cmd%
