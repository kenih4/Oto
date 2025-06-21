Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);
    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
}
"@

$null = [Win32]::EnumWindows({ 
    param($hWnd, $lParam)
    if ([Win32]::IsIconic($hWnd)) {
        [Win32]::ShowWindow($hWnd, 9)  # SW_RESTORE = 9
    }
    return $true
}, [IntPtr]::Zero)
