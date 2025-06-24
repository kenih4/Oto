#! c:/perl/bin/perl -w
use Socket;
use LWP::Simple;
use Switch;
use Time::Local;
use Time::Piece;
#use Win32::Console;
use Cwd;
use Net::Ping;
use File::Path;
#use warnings;
use v5.10;
use Term::UI;
use Term::ReadLine;
use POSIX qw(strftime);
use DateTime;
use POSIX 'strftime';

use Win32::Sound;
Win32::Sound::Volume('100%');

use win32;

use feature qw(say);
use strict;
use warnings;
use Net::SMTPS;

use Win32::GuiTest qw(FindWindowLike SetForegroundWindow);



=pod
sleep 100;
$line = <STDIN>;

http://websvr02.spring8.or.jp/cgi-bin/syncdaq/plot_multi.cgi?&Command=plot&LeftSignals=xfel_llrf_cb03_4_iq_acc_1_dload_ta/phase&XY=Trend&BeginTime=2016-06-7 15:00:00&EndTime=2016-06-7 15:30:0&Selection=Time&LeftMax=&LeftMin=
http://websvr02.spring8.or.jp/cgi-bin/syncdaq/plot_multi.cgi?&Command=plot&LeftSignals=xfel_llrf_cb03_4_iq_acc_1_dload_ta/phase&XY=Trend&BeginTime=2016-06-7%2015:00:00&EndTime=2016-06-7%2015:30:0&Selection=Time&LeftMax=177.5&LeftMin=178.5

http://websvr02.spring8.or.jp/cgi-bin/syncdaq/plot_multi.cgi?&Command=plot&LeftSignals=xfel_llrf_cb03_4_iq_acc_1_dload_ta/phase&XY=Trend&BeginTime=2016-06-28 11:30:00&EndTime=2016-06-28 12:00:0&Selection=Time&LeftMax=&LeftMin=
http://websvr02.spring8.or.jp/cgi-bin/syncdaq/plot_multi.cgi?&Command=plot&LeftSignals=xfel_llrf_cb03_4_iq_acc_1_dload_ta/phase&XY=Trend&BeginTime=2016-06-28%2011:30:00&EndTime=2016-06-28%2012:00:0&Selection=Time&LeftMax=164.8&LeftMin=165.8

Usage:

	モジュールインストール
	cpan Switch
	cpan Win32::Sound


	実験棟
	perl oto17_Ntfy_Upper_Lower.pl xfel_bl_3_tc_bm_1_pd/charge 93 1000 0.02 oto0.wav 3
	perl oto17_Ntfy_Upper_Lower.pl xfel_mon_msbpm_bl3_dump_1_beamstatus/summary 80 101 0.03 oto0.wav 15

	加速器 xfel_mon_msbpm_bl3_dump_1_y/potition
	perl oto17_Ntfy_Upper_Lower.pl 550648 98 102 0.02 oto0.wav 3

	新しくターミナルを開いて実行する場合
	start cmd /k perl oto17_Ntfy_Upper_Lower.pl xfel_bl_3_tc_bm_1_pd/charge 93 1000 0.02 oto0.wav 3


	pp -o oto.exe oto17_Ntfy_Upper_Lower.pl



# ターミナルサイズ変更したいがこれだとダメ
use Win32::Console;
my $console = Win32::Console->new();
$console->Window(0, 0, 19, 19);  # left, top, right, bottom（0ベース）
$console->Cursor(0, 0);
print "Changed Terminal Size!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";


#一時ファイル作成に以下のものを使うと、GLOB(0x....)という謎のファイルができてしまう
use File::Temp qw/ tempfile /;
my ($out, $tempfilename) = tempfile( UNLINK => 1 );
my ($errlog, $tempfilename_errlog) = tempfile( UNLINK => 1 );
print  "Temp file :	[$tempfilename]	Created by File::Temp\n";
print  "Temp file stderr :	[$tempfilename_errlog]	Created by File::Temp\n";

コマンドプロンプトのウィンドウタイトル
「C:\windows\system32\cmd.exe - perl  oto17_Ntfy_Upper_Lower.pl xfel_bl_3_tc_bm_1_pd/charge 93 1000 0.02 oto0.wav 3」
「C:\windows\system32\cmd.exe - perl  oto17_Ntfy_Upper_Lower.pl xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage 90 1000 0.02 oto0.wav 3」

=cut





# タイトルに "コマンド プロンプト" を含むウィンドウを最前面に　ダメ
#my @windows = FindWindowLike(0, "C:\windows\system32\cmd.exe - perl  oto17_Ntfy_Upper_Lower.pl xfel_bl_1_tc_gm_1_pd_fitting_peak/voltage 90 1000 0.02 oto0.wav 3"); # ウィンドウタイトルに応じて変えてください
#SetForegroundWindow($windows[0]) if @windows;






#my $tmpdir = $ENV{TMP} || $ENV{TEMP};
use File::Spec;
my $tmpdir = File::Spec->tmpdir; # OS依存がないのでこの方法がよい
print "Temp folder :	$tmpdir\n";


#mail_send('A','B','C');
#system("python Send_notification_by_pushbullet.py Start");
system("curl -d \"Start_$ARGV[0]\" ntfy.sh/Uz44wThqEATElY48");
#exit(0);

printf "signal=%s	thre_LOW=%s thre_UP=%s	volume=%s	wav_file=%s	cnt_limit=%s\n\n",$ARGV[0],$ARGV[1],$ARGV[2],$ARGV[3],$ARGV[4],$ARGV[5];

print "ABC\e[4;31;44mDEF\e[0mGHI\n";
print "ABC\e[38;5;45mDEF\e[0mGHI\n";

#open(STDERR,">"."$tmpdir/stderr.log") or die "CANNOT redirect STDERR to stderr.log";

use constant {
    SHOTNUM => 1000,
	WAITSEC => 420,
	VAL  => 1,
};





my $t = localtime;

my $year   = $t->year;
my $month  = $t->mon;
my $mday   = $t->mday;
my $hour   = $t->hour;
my $minute = $t->minute;
my $second = $t->sec;
#printf "year=%d	\n\n",$year;

my $dt = DateTime->new( 
  year => $t->year,
  month => $t->mon,
  day => $t->mday,
  hour => 1,
  minute => 0,
  second => 0,
);
printf "$dt	\n\n";







my $host = "http://websvr02.spring8.or.jp";


my @wav = ("oto0.wav","oto1.wav","oto2.wav","oto3.wav","oto4.wav","oto5.wav","oto6.wav","oto7.wav","oto8.wav","oto9.wav");
my @wav_other = ("teishi.wav");
my $sta_date="2016-09-27 00:00:00";
my $sto_date="2016-09-27 00:00:01";	


my $url;
if ($ARGV[0] =~ /^[0-9]+$/) {
	print "$ARGV[0]		ACC\n";
	$url = &Syncdaq_ACC("1",$ARGV[0],"","","","","","","Trend","","","Trigger","","100","submit","-1","evno","4","asc","dot","text","0","on");
}else{
	print "$ARGV[0] 	EXP\n";
	$url = &Syncdaq_EXP("data",$ARGV[0],"","","","","","","","","","","","Trend","","","",SHOTNUM,"Trigger");
}
print  "url	$url\n";
#return;

# - - - - - - - 
my $n_wav=0;
my $cnt=0;
my $initial_value = 0;

my $thre_LOW    =   $ARGV[1];
my $thre_UP =       $ARGV[2];
my $vol =           $ARGV[3];
my $wav_file    =   $ARGV[4];
my $cnt_limit   =   $ARGV[5];

my  $dt_before = DateTime->now(time_zone => 'Asia/Tokyo');
#printf "dt_before	=  $dt_before	\n\n";



















while(1){

	my  $dt_after = DateTime->now(time_zone => 'Asia/Tokyo');
#	printf "-dt_before	=  $dt_before	\n";
#	printf "-dt_after	=  $dt_after	\n\n";

	my $hour_before = $dt_before->hour;
	my $minute_before = $dt_before->minute;
	my $hour_after = $dt_after->hour;
	my $minute_after = $dt_after->minute;
#	printf "dt_before		$hour_before	:$minute_before	\n";
#	printf "dt_after		$hour_after	:$minute_after	\n";

	if($hour_before!=$hour_after and $hour_before==0){
#	if($minute_before!=$hour_after and $minute_before==16){	# TEST
		print  "Finish!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
		exit(0);
	} 

	if($hour_before!=$hour_after and $hour_before==16){
		print  "Finish!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
		exit(0);
	} 

	if($hour_before!=$hour_after and $hour_before==8){
		print  "Finish!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
		exit(0);
	} 




    my $dt_n = DateTime->now(time_zone => 'Asia/Tokyo');

my @result;
if ($ARGV[0] =~ /^[0-9]+$/) {
	#print "$ARGV[0]		ACC\n";
	#@result = Get_only_data_ACC($url,"C:\\Users\\kenic\\AppData\\Local\\Temp\\out.txt");
	@result = Get_only_data_ACC($url,"$tmpdir/out.txt");
}else{
	#print "$ARGV[0] 	EXP\n";
	#@result = Get_only_data_EXP($url,"C:\\Users\\kenic\\AppData\\Local\\Temp\\out.txt");	
	@result = Get_only_data_EXP($url,"$tmpdir/out.txt");
}
#	print $url;
#	print  "result	@result\n";

	my $damepulse_rate = (1 - $result[3])*100;

	if($initial_value==0){   $initial_value = $result[3];   }

	my $perc = ($result[3]/$initial_value)*100;	

	if ($ARGV[0] =~ /^[0-9]+$/) {
		#print "$ARGV[0]		ACC\n";
		print  "$dt_n: $ARGV[0]    	mean = $result[3]($perc%)%\n";
	}else{
		#print "$ARGV[0] 	EXP\n";
		print  "$dt_n: $ARGV[0]    $result[5]/",SHOTNUM,"	$result[6]/",SHOTNUM,"	mean = $result[3]($perc%)	DAMEPALUSE = $damepulse_rate %\n";
	}

	#	Many Not Converged (ex. Beam stop)
	if($result[5] >= 500){
		print  "Onsei Teishi	n_wav = $wav_other[0]\n";
	    system("change_volume.exe 0.01");        
		Win32::Sound::Play("wav/".$wav_other[0],SND_NOSTOP);
		Win32::Sound::Stop();
		system("curl -d \"$dt_n	$ARGV[0]	Many Not Converged\" ntfy.sh/Uz44wThqEATElY48");
		sleep(WAITSEC);
	}


#	if( (($result[3] < $thre_LOW) || ($result[3] > $thre_UP)) && $result[5] < 200){
	if( (($perc < $thre_LOW) || ($perc > $thre_UP)) && $result[5] < 200){
		print  "\e[38;5;1m cnt = $cnt \e[0m\n";
		$n_wav++;

		if($cnt >= $cnt_limit){
			print  "\e[48;5;124m Onsei!!!		[$perc]			<$wav_file> \e[0m\n";
			Win32::MsgBox($ARGV[0], 0 + 48, "Caption");
#			mail_send($ARGV[0], ($result[3]/$initial_value)*100);
#			system("python Send_notification_by_pushbullet.py $ARGV[0]");
			system("curl -d \"$dt_n	$ARGV[0]	$perc % \" ntfy.sh/Uz44wThqEATElY48");

			system("change_volume.exe $vol");
#			Win32::Sound::Volume($vol);
			Win32::Sound::Play("wav/".$wav_file,SND_NOSTOP);
			Win32::Sound::Stop();

			print  "sleep ,	",WAITSEC,"..........................................\n";
			sleep(WAITSEC);
			$cnt = 0;
		}
		if($n_wav >= 10){    $n_wav=0;  }
		$cnt++;
	}else{
		$cnt = 0;
	}


	$dt_before = DateTime->now(time_zone => 'Asia/Tokyo');
#	printf "dt_before	=  $dt_before	\n\n";


	sleep(35);
	#Get_img ($url,"out.png");




}
# - - - - - - - 


#close(STDERR);


print "\n END \n\n";















#-----------------------------------------------------------------------------------------------------------------
sub Get_data{  
	open(OUT_Get_data, "> $_[1]");
	
	my $url=$_[0];
#	$url =~ s/Command=/Command=data/g;

	my $contents = get($url);
	$contents =~ s/<.*?>//g;
#	print  "$contents\n";

	my @line = split(/\n/, $contents);
	
	

	foreach ( @line ) {
	#		print  "$_\n";
#		print  "$_\n" unless /^\s*$/;
		if($_!~/SyncDAQ/){
			print  OUT_Get_data	"$_\n" unless /^\s*$/;
		}
	}
	close(OUT_Get_data);	
}



#-----------------------------------------------------------------------------------------------------------------
sub Get_only_data_EXP{  
	open(OUT_Get_data, "> $_[1]");
	
	my $cnt=0, my $sum=0,my $mean=0;
	my $min,my $max;
	my $url=$_[0];
	my $cnt_not_converged=0;
	my $cnt_saturated=0;	
#	$url =~ s/Command=/Command=data/g;

	my $contents = get($url);
	$contents =~ s/<.*?>//g;
#	print  "$contents\n";

	my @line = split(/\n/, $contents);
	
	foreach ( @line ) {
#		print  "$_\n";
#		print  "$_\n" unless /^\s*$/;
		if($_!~/SyncDAQ/ & $_!~/Trigger*/){
			my @data = split(/ /, $_);
#			print "@data[0]\t@data[1]\t@data[2]\t@data[3]\n";			
			
			if($data[1] =~/[0-9]{4}-[0-9]{2}-[0-9]{2}/){	
					if($data[3] eq "not-converged"){
						$cnt_not_converged++;
					}elsif($data[3] eq "saturated"){
						$cnt_saturated++;
					}else{

						$data[3] =~ s/[A-Za-z]$//; # 末尾のアルファベット一文字を削除
						#print "Value: $data[3]\n"; # 出力: 数値だけ: 1.234E+05

						$min = $data[3]		if($cnt==0);				
						$max = $data[3]		if($cnt==0);		
						$min = $data[3]		if($data[3] < $min);
						$max = $data[3]		if($data[3] > $max);
						$sum += $data[3];			
						$cnt++;		
					}
			}else{
#				print "NOT DATE\n";			
			}




=pod	
			@data[3] =~ s/[a-z]//g;
			@data[3] =~ s/[A-Z]//g;
#			print "@data[3]\n";
			print "@data[0]\t@data[1]\t@data[2]\t@data[3]\n";
		
			if(@data[3] =~/^[0-9]*$/){
#				print "Not number\n";
			}else{
				$min = @data[3]		if($cnt==0);
				$max = @data[3]		if($cnt==0);				
				$min = @data[3]		if(@data[3] < $min);
				$max = @data[3]		if(@data[3] > $max);
#				$tmp = @data[3];
				$sum += @data[3];			
				$cnt++;
#				print "Number\n";
			}
=cut

			print  OUT_Get_data	"$data[3]\n" unless /^\s*$/;
		}
	}
	close(OUT_Get_data);
	if($cnt > 0){	
		$mean=$sum/$cnt;
	}	
#	print "min = $min	max = $max	sum=$sum	mean=$mean	cnt=$cnt	cnt_not_converged=$cnt_not_converged	cnt_saturated=$cnt_saturated\n";

	return $min,$max,$sum,$mean,$cnt,$cnt_not_converged,$cnt_saturated;
}





#-----------------------------------------------------------------------------------------------------------------
sub Get_only_data_ACC{  
	open(OUT_Get_data, "> $_[1]");
	
	my $cnt=0, my $sum=0,my $mean=0;
	my $min,my $max;
	my $url=$_[0];
	my $cnt_not_converged=0;
	my $cnt_saturated=0;	

	my $contents = get($url);
	$contents =~ s/<.*?>//g;
#	print  "$contents\n";

	my @line = split(/\n/, $contents);
	
	foreach ( @line ) {
#		print  "$_\n";
#		print  "$_\n" unless /^\s*$/;
		if($_!~/SyncDAQ/ & $_!~/Trigger*/){
			my @data = split(/,/, $_);
#			print "@data[0]\t@data[1]\t@data[2]\t@data[3]\n";
			if($data[1] =~/[0-9]{4}\/[0-9]{2}\/[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}/){	
					#print "D	min = $min	max = $max	sum=$sum	mean=$mean	cnt=$cnt\n";
						$min = $data[2]		if($cnt==0);				
						$max = $data[2]		if($cnt==0);		
						$min = $data[2]		if($data[2] < $min);
						$max = $data[2]		if($data[2] > $max);
						$sum += $data[2];			
						$cnt++;		
			}else{
#				print "NOT DATE\n";			
			}
			print  OUT_Get_data	"$data[3]\n" unless /^\s*$/;
		}
	}
	close(OUT_Get_data);

	if($cnt > 0){	
		$mean=$sum/$cnt;
	}
#	print "min = $min	max = $max	sum=$sum	mean=$mean	cnt=$cnt\n";

	return $min,$max,$sum,$mean,$cnt,$cnt_not_converged,$cnt_saturated;
}




#-----------------------------------------------------------------------------------------------------------------
sub Get_img{  
	my $url=$_[0];
	$url =~ s/Command=/Command=plot/g;	
	my $contents = get($url);

	#print  "$contents\n";
	
	if ($contents =~ m#<img src="(.*?)">#) {
	   my $h1 = $1;
	   print  "IMG SRC =  $h1\n";
	  #system("firefox http://websvr02.spring8.or.jp/$1");
	  Get_img_file($host.$1,"$_[1]"); 
	}
}












#-----------------------------------------------------------------------------------------------------------------

sub Syncdaq_EXP{  
#MOTO	my $url = $host."/cgi-bin/syncdaq/plot_multi.cgi?&Command=&LeftSignals=&LeftMax=&LeftMin=&LeftLogy=&RightSignals=&RightMax=&RightMin=&RightLogy=&XSignals=&XMax=&XMin=&XLog=&XY=&BeginTime=&EndTime=&StartTrigger=&Ndata=&Selection=&BeginStr=&EndStr=&TriggerStr=";

#	http://websvr02.spring8.or.jp/syncdaq/xdaq.html
#ref		var url = 'http://SRV/cgi-bin/xdaq/plot_multi.cgi?&Command=data&LeftSignals=SIGNAME&LeftMax=&LeftMin=&LeftLogy=&RightSignals=&RightMax=&RightMin=&RightLogy=&XSignals=&XMax=&XMin=&XLog=&XY=Trend&BeginTime=STA&EndTime=STO&Selection=Time';
	
	my $url = $host."/cgi-bin/xdaq/plot_multi.cgi?&Command=&LeftSignals=&LeftMax=&LeftMin=&LeftLogy=&RightSignals=&RightMax=&RightMin=&RightLogy=&XSignals=&XMax=&XMin=&XLog=&XY=&BeginTime=&EndTime=&StartTrigger=&Ndata=&Selection=&BeginStr=&EndStr=&TriggerStr=";	
	
	foreach ( @_ ) {
#		print  "$_\n";
	}
	
	$url =~ s/Command=/Command=$_[0]/g;
	$url =~ s/LeftSignals=/LeftSignals=$_[1]/g;
	$url =~ s/LeftMax=/LeftMax=$_[2]/g;
	$url =~ s/LeftMin=/LeftMin=$_[3]/g;
	$url =~ s/LeftLogy=/LeftLogy=$_[4]/g;
	$url =~ s/RightSignals=/RightSignals=$_[5]/g;
	$url =~ s/RightMax=/RightMax=$_[6]/g;
	$url =~ s/RightMin=/RightMin=$_[7]/g;
	$url =~ s/RightLogy=/RightLogy=$_[8]/g;
	$url =~ s/XSignals=/XSignals=$_[9]/g;
	$url =~ s/XMax=/XMax=$_[10]/g;
	$url =~ s/XMin=/XMin=$_[11]/g;
	$url =~ s/XLog=/XLog=$_[12]/g;
	$url =~ s/XY=/XY=$_[13]/g;
	$url =~ s/BeginTime=/BeginTime=$_[14]/g;
	$url =~ s/EndTime=/EndTime=$_[15]/g;
	$url =~ s/StartTrigger=/StartTrigger=$_[16]/g;
	$url =~ s/Ndata=/Ndata=-$_[17]/g;
	$url =~ s/Selection=/Selection=$_[18]/g;
	$url =~ s/BeginStr=/BeginStr=$_[19]/g;
	$url =~ s/EndStr=/EndStr=$_[20]/g;
	$url =~ s/TriggerStr=/TriggerStr=$_[21]/g;

#	print  "url	$url\n";
	return $url;
}




#-----------------------------------------------------------------------------------------------------------------

sub Syncdaq_ACC{  


#	my $url = $host."/cgi-bin/xdaq/plot_multi.cgi?&Command=&LeftSignals=&LeftMax=&LeftMin=&LeftLogy=&RightSignals=&RightMax=&RightMin=&RightLogy=&XSignals=&XMax=&XMin=&XLog=&XY=&BeginTime=&EndTime=&StartTrigger=&Ndata=&Selection=&BeginStr=&EndStr=&TriggerStr=";	

#	http://srweb-dmz-03.spring8.or.jp/cgi-bin/MDAQ/mdaq_sync_plot.py?daq_type=1&lsig=550648&lmin=&lmax=&rmin=&rmax=&xmin=&xmax=&XY=Trend&begin_bt=2023%2F10%2F18+04%3A36%3A39&end_bt=2023%2F10%2F18+04%3A37%3A39&Selection=Trigger&TriggerStr=&Ndata=200&s=submit&sampling=-1&filter=evno&route_sel=4&data_order=asc&plot_style=dot&Command=text&runave=0&hide_err=on
	
	my $url = "http://srweb-dmz-03.spring8.or.jp/cgi-bin/MDAQ/mdaq_sync_plot.py?daq_type=&lsig=&lmin=&lmax=&rmin=&rmax=&xmin=&xmax=&XY=&begin_bt=&end_bt=&Selection=&TriggerStr=&Ndata=&s=&sampling=&filter=&route_sel=&data_order=&plot_style=&Command=&runave=&hide_err=";



	foreach ( @_ ) {
#		print  "$_\n";
	}
	
	$url =~ s/daq_type=/daq_type=$_[0]/g;
	$url =~ s/lsig=/lsig=$_[1]/g;
	$url =~ s/lmin=/lmin=$_[2]/g;
	$url =~ s/lmax=/lmax=$_[3]/g;
	$url =~ s/rmin=/rmin=$_[4]/g;
	$url =~ s/rmax=/rmax=$_[5]/g;
	$url =~ s/xmin=/xmin=$_[6]/g;
	$url =~ s/xmax=/xmax=$_[7]/g;
	$url =~ s/XY=/XY=$_[8]/g;
	$url =~ s/begin_bt=/begin_bt=$_[9]/g;
	$url =~ s/end_bt=/end_bt=$_[10]/g;
	$url =~ s/Selection=/Selection=$_[11]/g;
	$url =~ s/TriggerStr=/TriggerStr=$_[12]/g;
	$url =~ s/Ndata=/Ndata=$_[13]/g;
	$url =~ s/s=/s=$_[14]/g;
	$url =~ s/sampling=/sampling=$_[15]/g;
	$url =~ s/filter=/filter=$_[16]/g;
	$url =~ s/route_sel=/route_sel=$_[17]/g;	
	$url =~ s/data_order=/data_order=$_[18]/g;
	$url =~ s/plot_style=/plot_style=$_[19]/g;
	$url =~ s/Command=/Command=$_[20]/g;
	$url =~ s/runave=/runave=$_[21]/g;
	$url =~ s/hide_err=/hide_err=$_[22]/g;
#	print  "url	$url\n";
	return $url;
}









#-----------------------------------------------------------------------------------------------------------------
sub Get_img_file{  

	my $url  = $_[0];
	my $file = $_[1];

	print "URL	$url\n";	
	print "FILE	$file\n";	
	$url =~ s/http\:\/\///g;
	my ($host,$path)=split(/\//,$url,2);	
	print "host 	$host\n";
	print "path 	$path\n";	
	my $ipadd = inet_aton("$host") or die "Can't pack $host -> Binary: $!";

	print "ipadd 	$ipadd\n";	

	my $scktadd = pack_sockaddr_in(80,$ipadd);
	print "scktadd	$scktadd\n\n";	
	socket(SOCKET,PF_INET,SOCK_STREAM,0);
	my $ret = connect(SOCKET,$scktadd);
	printf "\nERR(%d)\n", $ret and sleep 3 and exit(0) if($ret != 1);
	select(SOCKET);$ |= 1;select(STDOUT);
	print SOCKET "GET /$path HTTP/1.0\r\n";
	print SOCKET "HOST: $host\r\n";
	print SOCKET "\r\n";

	while(<SOCKET>){m/^\r\n$/ and last;}

	open(FILE, ">".$file);
	binmode(FILE); 
	while (<SOCKET>){print FILE "$_";}
	close(FILE);
} 







sub mail_send() {

	my $now = strftime "%Y/%m/%d %H:%M:%S", localtime;

	my $smtp = Net::SMTPS->new(
		'sp8smtp.spring8.or.jp',
		Port    => 25,
		Timeout => 20,
		Debug   => 1,
		doSSL   => 'starttls',
	);
	die "Initialization failed: $!" if !defined $smtp;

	my $sender = my $user = 'kenichi@spring8.or.jp';
	my $password = 'ribsgroup';
	say "Trying to authenticate..";
	$smtp->auth( $user, $password, 'LOGIN'  );  # or die "could not authenticate\n";
	#$smtp->auth( $user, $password, 'PLAIN'  ) or die "could not authenticate\n";
	#$smtp->auth( $user, $password, 'CRAM-MD5'  ) or die "could not authenticate\n";
	#$smtp->auth( $user, $password, 'DIGEST-MD5'  ) or die "could not authenticate\n";

	my $receiver = 'kenih4@gmail.com';    
	$smtp->mail( $sender );
	$smtp->to( $receiver );
	$smtp->data();
	$smtp->datasend( "To: $receiver\n" );
	$smtp->datasend( "From: $sender\n" );
	$smtp->datasend( "Content-Type: text/html\n" );
    $smtp->datasend( "Subject: Testing Net::SMTPS	Send time:".$now);
	$smtp->datasend( "\n" );
	$smtp->datasend( 'The body of the email\n	');
	$smtp->datasend( 'Signal:	'.$_[0].'	Pecentage:'.$_[1] );
	$smtp->datasend( "	\n	" );
	$smtp->datasend( $now );
	$smtp->dataend();
	$smtp->quit();
	say "Done.";
}










=pod
&Command=COMMAND
&LeftSignals=SNAME_L
&LeftMax=MAX_L
&LeftMin=MIN_L
&LeftLogy=LOG_L
&RightSignals=SNAME_R
&RightMax=MAX_R
&RightMin=MIN_L
&RightLogy=LOG_L
&XSignals=SNAME_X
&XMax=MAX_X
&XMin=MIN_X
&XLog=LOG_X
&XY=XY_MODE
&BeginTime=STA_DATE
&EndTime=STO_DATE
&StartTrigger=START_TRIG
&Ndata=NDATA
&Selection=SELECTION
&BeginStr=STA_STR
&EndStr=STO_STR
&TriggerStr=TRIG_STR

0 &Command=
1 &LeftSignals=
2 &LeftMax=
3 &LeftMin=
4 &LeftLogy=
5 &RightSignals=
6 &RightMax=
7 &RightMin=
8 &RightLogy=
9 &XSignals=
10 &XMax=
11 &XMin=
12 &XLog=
13 &XY=
14 &BeginTime=
15 &EndTime=
16 &StartTrigger=
17 &Ndata=
18 &Selection=
19 &BeginStr=
20 &EndStr=
21 &TriggerStr=


	
$_ =~ s/&Command=/Command=/g;
$_ =~ s/&LeftSignals=/LeftSignals=/g;
$_ =~ s/&LeftMax=/LeftMax=/g;
$_ =~ s/&LeftMin=/LeftMin=/g;
$_ =~ s/&LeftLogy=/LeftLogy=/g;
$_ =~ s/&RightSignals=/RightSignals=/g;
$_ =~ s/&RightMax=/RightMax=/g;
$_ =~ s/&RightMin=/RightMin=/g;
$_ =~ s/&RightLogy=/RightLogy=/g;
$_ =~ s/&XSignals=/XSignals=/g;
$_ =~ s/&XMax=/XMax=/g;
$_ =~ s/&XMin=/XMin=/g;
$_ =~ s/&XLog=/XLog=/g;
$_ =~ s/&XY=/XY=/g;
$_ =~ s/&BeginTime=/BeginTime=/g;
$_ =~ s/&EndTime=/EndTime=/g;
$_ =~ s/&StartTrigger=/StartTrigger=/g;
$_ =~ s/&Ndata=/Ndata=/g;
$_ =~ s/&Selection=/Selection=/g;
$_ =~ s/&BeginStr=/BeginStr=/g;
$_ =~ s/&EndStr=/EndStr=/g;
$_ =~ s/&TriggerStr=/TriggerStr=/g;




	
	
	

=cut
