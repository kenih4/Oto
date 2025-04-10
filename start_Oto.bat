@echo off

color 1d

echo arg1: %1
echo arg2: %2
echo arg3: %3

rem	mode 100,10

rem	perl oto.pl xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage 0.8


rem	xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage
rem	xfel_bl_2_tc_bm_1_pd/charge
rem	xfel_bl_3_tc_bm_1_pd/charge



rem	call powershell.exe -windowStyle Hidden -command "C:\me\Oto\change_volume.ps1" "0.47"

rem	change_volume.exe 0.3

rem	oto.exe xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage 0.8


rem	change_volume.exe %1

rem	start oto.exe %2 %3

rem start /MIN oto.exe %1 %2 %3 %4 %5 %6

rem(LATEST) start oto.exe %1 %2 %3 %4 %5 %6

start cmd /k perl oto17_Ntfy_Upper_Lower.pl %1 %2 %3 %4 %5 %6

rem start oto.exe --window-position=100,0 --window-size=500,150 %1 %2 %3 %4 %5                  DAME

 

rem	pause



