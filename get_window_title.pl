use strict;
use warnings;
use Win32::GuiTest qw(FindWindowLike GetWindowText);

my @windows = FindWindowLike();  # すべてのトップレベルウィンドウ

foreach my $win (@windows) {
    my $title = GetWindowText($win);
    print "$win: $title\n" if $title;  # タイトルが空でなければ表示
}



# 最前面にテスト
use Win32::GuiTest qw(FindWindowLike SetForegroundWindow);
#my @windows = FindWindowLike(0, "C:\windows\system32\cmd.exe - perl  oto17_Ntfy_Upper_Lower.pl xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage 90 1000 0.02 oto0.wav 3"); # ウィンドウタイトルに応じて変えてください
#my @windows = FindWindowLike(0, "C:\\windows\\system32\\cmd.exe - perl  oto17_Ntfy_Upper_Lower.pl xfel_bl_1_tc_gm_1_pd_fitting_peak\/voltage 90 1000 0.02 oto0.wav 3"); # ウィンドウタイトルに応じて変えてください
my @windows = FindWindowLike(0, "コマンドプロンプト");
SetForegroundWindow($windows[0]) if @windows;

print "windows[0]:  $windows[0]\n";
print $windows[0];


# 自分の端末（ターミナル）ウィンドウIDを取得
my $wid = `xdotool getactivewindow`;
chomp $wid;
print $wid;

use win32;
Win32::MsgBox("Message", 1 + 48, "Caption");

print "END\n";