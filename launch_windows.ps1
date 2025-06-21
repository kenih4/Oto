param (
    [string]$shortcut,
    [int]$x = 0,
    [int]$y = 0
)
Write-Host shortcut: $shortcut, x: $x, y: $y


$wsShell = New-Object -ComObject WScript.Shell # WScript.Shell COM オブジェクトを作成
$shortcut_obj = $wsShell.CreateShortcut($shortcut)

# リンク先（TargetPath）を取得
$targetPath = $shortcut_obj.TargetPath

# 引数（Arguments）を取得
$arguments = $shortcut_obj.Arguments

# リンク先と引数を結合して完全なコマンドラインを生成
if (-not [string]::IsNullOrWhiteSpace($arguments)) {
    $fullLinkTarget = "$targetPath $arguments"
} else {
    $fullLinkTarget = $targetPath
}

# 取得した情報を表示
#Write-Host "Path: $shortcutPath"
#Write-Host "TargetPath: $targetPath"
#Write-Host "Arguments: $arguments"
#Write-Host "fullLinkTarget: $fullLinkTarget"
Get-Process | Where-Object { $_.MainWindowTitle -eq $fullLinkTarget }
#$WinTitle = [System.IO.Path]::GetFileNameWithoutExtension($shortcut)
#Write-Host "Pause..."
#Read-Host


$sh = New-Object -ComObject WScript.Shell
$sc = $sh.CreateShortcut($shortcut)

$exe = $sc.TargetPath
$args = $sc.Arguments

Start-Process 'cmd.exe' -ArgumentList "/k `"$exe $args & pause`"" -WindowStyle Normal
Start-Sleep -Milliseconds 500

Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class NativeMethods {
    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
}
"@



#C:\windows\system32\cmd.exe - C:\Strawberry\perl\bin\perl.exe  C:\Users\kenic\Dropbox\gitdir\Oto\oto17_Ntfy_Upper_Lower.pl  xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage 99 1000 0.02 oto0.wav 3 
#PS C:\Users\kenic\Dropbox\gitdir\Oto> Get-Process | Where-Object { $_.MainWindowTitle -eq "C:\windows\system32\cmd.exe - C:\Strawberry\perl\bin\perl.exe  C:\Users\kenic\Dropbox\gitdir\Oto\oto17_Ntfy_Upper_Lower.pl  xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage 99 1000 0.02 oto0.wav 3 " }
#Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
#-------  ------    -----      -----     ------     --  -- -----------
#    709      36    81880     144628       1.84   9584   3 WindowsTerminal

#Get-Process | Where-Object { $_.MainWindowTitle -eq "testBL1" }
#Get-Process -Name "WindowsTerminal"
#Get-Process cmd
#$proc = Get-Process cmd | Sort-Object StartTime -Descending | Select-Object -First 1
$proc = Get-Process -Name "WindowsTerminal" | Sort-Object StartTime -Descending | Select-Object -First 1
Write-Host proc: $proc
[NativeMethods]::MoveWindow($proc.MainWindowHandle, $x, $y, 800, 400, $true)
