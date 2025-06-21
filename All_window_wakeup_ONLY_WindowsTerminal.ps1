Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);    
}
"@

$targetName = "WindowsTerminal"

$null = [Win32]::EnumWindows({
    param($hWnd, $lParam)
    $null = [Win32]::GetWindowThreadProcessId($hWnd, [ref]$mypid)
    try {
        $proc = Get-Process -Id $mypid -ErrorAction Stop
        if ($proc.ProcessName -eq $targetName) {
            $isMinimized = [Win32]::IsIconic($hWnd)
            Write-Host "[$($proc.ProcessName)] hWnd=$hWnd IsIconic=$isMinimized"
            if ($isMinimized) {
                [Win32]::ShowWindow($hWnd, 9)
            }
        }
    } catch {}
    return $true
}, [IntPtr]::Zero)