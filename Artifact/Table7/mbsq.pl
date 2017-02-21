#!/usr/bin/perl

# > time perl mbsqlocal.pl  http://www.ntu.edu.tw/english/index.html &
# > time perl mbsqlocal.pl  http://www.richpuppy.net/AutomtTest/index.html  &   
# > time perl mbsqlocal.pl  http://www.iis.sinica.edu.tw/pages/scm/ &
# > time perl mbsq.pl  http://tigp.sinica.edu.tw/FAQ.html &
# > time perl mbsq.pl  http://www.iis.sinica.edu.tw/page/computer/BorrowSoftwaresorEquipments.html  &
# > time perl mbsq.pl  http://www.iis.sinica.edu.tw/page/research/ProgrammingLanguagesandFormalMethods.html &
#
# If running on Local Host
# > time perl mbsq.pl  http://www.richpuppy.net/AutomtTest/index.html local  &   
# > time perl mbsq.pl  http://www.ntu.edu.tw/english local&

#use strict;
#use warnings;
use IO::Handle;
use threads;
use threads::shared;
use Time::HiRes qw/time sleep/;
require './qsubs.pl';

$WebCnt = 0;
$loopcnt = 0;
$routecnt = 0;
$acode = 0;
$dateIs = `date "+ %m%d%y-%H%M"`;
$dateIs =~ s/^\s+|\s+$//g;     # trim leading and tailing spaces
$mlinp = "MLoutput";
$wdir = "../webdir_mbq";
$urlrt = "";
my @aryhm = ();
my $curpath = "";

our @Bcntarry : shared = ();
our @TTtsarry : shared = ();

# get the first site by reading command argument
$argstr = &parseargv();
@argstr = split(/,/, $argstr);

$hmfile = $argstr[0];
$localy = $argstr[1];

if ($hmfile =~ /ntu/) {
  #$urlrt = "http://www.ntu.edu.tw/english/";  
  $urlrt = "http://www.ntu.edu.tw/";
  $wdir = "../webdir_mbq_ntu";
  #get current path
  @aryhm = split(/\//,$hmfile);
  pop @aryhm;
  foreach $a (@aryhm) {
    #print "aryhm a=$a ********   ";
    $curpath .= $a."/";
  }
  #print "ntu curpath $curpath \n";
  $stn = "ntu";
} elsif ($hmfile =~ /stanford/) {
  $urlrt = "http://www.stanford.edu/academics/"; 
  $curpath = $urlrt;
  $wdir = "../webdir_mbq_stf";
  $stn = "ntu";
} elsif ($hmfile =~ /richpuppy/) { 
  $urlrt = "http://www.richpuppy.net/AutomtTest/";
  $curpath = $urlrt;
  $wdir = "../webdir_mbq_puppy";
  $stn = "puppy";
} elsif ($hmfile =~ /scm/) {
  $urlrt = "http://www.iis.sinica.edu.tw/pages/scm/";
  $curpath = $urlrt;
  $wdir = "../webdir_mbq_iis_scm";
  $stn = "iis";
} elsif ($hmfile =~ /tigp\.sinica/) {
  $urlrt = "http://tigp.sinica.edu.tw/";
  $curpath = $urlrt;
  $wdir = "../webdir_mbq_tigp";
  $stn = "iis";
} else {
  $urlrt = "http://www.iis.sinica.edu.tw/";
  $curpath = $urlrt;
  $wdir = "../webdir_mbq_iis";
  $stn = "iis";
}

if ($localy =~ /local/) { 
   my $lc = "http://localhost/";

   $hmfile =~ s/$urlrt/$lc/i;

   my @arr = split(/\//, $hmfile);

#   if ($hmfile =~ /\/$/) {  # when ended by /
#       $hmfile = $urlrt; 
       #print "----- ended by / , last arr=$arr[$#arr], hmfile= $hmfile\n";
#   }  else  {  # concatenate the last element
#       $hmfile = $urlrt.$arr[$#arr]; 
#   } 
}


if (!(-e $wdir)) {
    `mkdir $wdir`;
}

#print "wget  hmfile $hmfile\n";

#my %asscary;

my @arryloop = ();
my @arryroute = ();


$srchtmlfname = $wdir."/WW0-R0-h0.htmlsource";
#`wget $hmfile -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null`;
$wgetCmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 5 -w 1";
$wgetrun = system("2>&1 $wgetCmd | tee $wdir/wget.log 1>/dev/null 2>/dev/null");
$wgetcode = $wgetrun/256;
print "wgetrun code $wgetcode \n";

open(MLINP, "./$mlinp") || die ("couldn't open file $mlinp");
$i=0; 
while(<MLINP>) { 
    chop;
    $inprow = $_;
    $inprow =~ s/^\s+|\s+$//g;  #trim leading and tailing spaces
    if (length($inprow)>0) { $arrystates[$i] = $inprow; } 
    $i++;   
}

#the following assignments are good for short testing 
#my @arrystates = ();
#@arrystates = ("h11h2", "h1h12h10", "h2h1h15");
#@arrystates = ("h5h2", "h1h5", "h3h2h7", "h5h2h1h2");
#@arrystates = ("h2h3h1");
#@arrystates = ("h23h60h9");
my @statecnt = ();
my @stateinp = ();

#read file from MetaLab output to form the arrystates 
for ($routecnt=0; $routecnt<=$#arrystates; $routecnt++) { 

$stateinp[$routecnt] = $arrystates[$routecnt];

@inpstr=();
@inpstr = split(/h/,$stateinp[$routecnt]);  
#note:$inpstr[0] is an empty string
shift @inpstr;   # first empty element is eliminated

$stcnt = $#inpstr+1;

#foreach (@inpstr) { 
  #print "-".$_."-";
#}

@inpstr=();

#$stcnt = length($stateinp[$routecnt])/2;

$statecnt[$routecnt]=$stcnt;

}   # end of for routecnt

$routesize = $routecnt;

my $j=0; 
my $halt=50;   # the max number of routes before of pause
my $original_running_threads = threads->list(threads::running);
my $thr;
$scref = \@statecnt;
foreach (@stateinp) {
  $thr = threads->create ('process_inp', $_, $j, $scref, $urlrt, $curpath, $stn, $localy, \@Bcntarry, \@TTtsarry);
  $j++;  
  print "<<<<<<  j= $j\n";
  sleep 1; 
  # wait 25 seconds to avoid being halt by web access blocking
  #if ($j%$halt==0)  { sleep 1; } 
  #                    elsif ($j>600) { sleep 25; }
  #                    elsif ($j>800) { sleep 25; }  
  #                    elsif ($j>1000) { sleep 25; }
                      #else { sleep 25; }
  #}   
}

sleep 1 while (threads->list(threads::running) > $original_running_threads);

#$thr->join() if ($thr->is_joinable());

for (threads->list) 
{   $_->join() if ($_->is_joinable());
}

&ary2file(\@Bcntarry, "bout-1");
&ary2file(\@TTtsarry, "tout-1");

#die "The End of the script.  Please enjoy yourself ! ";

###############################################################################
#   read each row of input file, and obtain the next html link 
##############################################################################

sub process_inp {

local ($stinp, $rtcnt, $stcref, $urlr, $crpth, $stnm, $lcly, $bcntf, $tttsf) = @_;

my @stcntary = @{$stcref};
my $stcnt = $stcntary[$rtcnt];
my $curpath = $crpth;
my $urlrt = $urlr;
my @aryhm = ();

for ($loopcnt=0; $loopcnt<$stcnt; $loopcnt++) { 

my @arryhtml = (); 
my $urlroot = $urlr;

#print "\nprocess_inp curpath $curpath\n";
 
#@arryhtml = &parsehtml_good($srchtmlfname, $urlroot);

#
if ($stnm =~ /ntu/) {
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} elsif ($stnm =~ /stf/) {
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} elsif ($stnm =~ /puppy/) {
  $curpath = $urlrt;
  @arryhtml = &parsehtml_puppy($srchtmlfname, $curpath);
} else { 
  $curpath = $urlrt;
  @arryhtml = &parsehtml($srchtmlfname, $curpath);
}

# get the order number by reading the input string - each row  
$ordernumberis = &getorderno($stinp, $loopcnt);

#print "ordernumberis = $ordernumberis \n";

$hmfile =  $arryhtml[$ordernumberis-1];
$hmfile =~ s/^\s+|\s+$//g;    #trim leading and tailing spaces

#if ($hmfile !~ /www\.ntu\.edu\.tw/i) { last; } 
#if ($hmfile =~ /http:\/\/m\./i) { last; }     # out of the loop	   
#if ($hmfile =~ /statistics/i) { last; }     # out of the loop	   
#if ($hmfile =~ /news/i) { last; }     # out of the loop	   

#$srchtmlfname = "W".$WebCnt."-R".$rtcnt."-h".$ordernumberis."-"."htmlsource";
$srchtmlfname = "R".$rtcnt."-h".$ordernumberis."-W".$WebCnt."-"."htmlsource";
$srchtmlfname = $wdir."/".$srchtmlfname;

print "\nhmfile: $hmfile\n";
$curpath = "";
#get current path
@aryhm = split(/\//,$hmfile);
pop @aryhm;
foreach $a (@aryhm) {
  #print "aryhm a=$a ********   ";
  $curpath .= $a."/";
}


if ($lcly =~ /local/) {
   my $lc = "http://localhost/";
   $hmfile =~ s/$urlrt/$lc/i;
   my @arr = split(/\//, $hmfile);
}

print "process_inp 2 curpath $curpath\n";

#when the web link does not exist
if (!$hmfile) {
#if (length($hmfile)==0) {
   @{$bcntf}[$rtcnt] += 0;
   @{$tttsf}[$rtcnt] += 0;
   #print "***************  missing link $hmfile $srchtmlfname\n";
   last;   #out of the loopcnt
}

#global variable
$WebCnt++;

$asscary{$hmfile} = @arryhtml;

print "\nwget $srchtmlfname hmfile: $hmfile\n";

$wgetCmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 5 -w 1";
$wgetrun = system("2>&1 $wgetCmd | tee $wdir/wget.log 1>/dev/null 2>/dev/null");
$wgetcode = $wgetrun/256;
print "wgetrun system code $wgetcode \n";
 
# get website response time, only one time 
$tts = `LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH /usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;
#$tts = `/usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;

# change seconds to milliseconds
@{$tttsf}[$rtcnt] += ($tts*1000);

$wcc = `wc -c $srchtmlfname`;
@wcc = split(/\s+/,$wcc);
$bcnt = $wcc[0];

#$htmlwc=0;
#$htmlgrep = `grep "\.html" $srchtmlfname`;
#$htmlgot = $htmlgrep;
#while ($htmlgot =~ /.*?\.html(.+)/s) {  #including newlines
#    $htmlgot = $1;
#    $htmlwc++;
    #print "htmlwc: $htmlwc, remaining is $1\n";
    #print "htmlgot: $htmlgot\n";
#}

@{$bcntf}[$rtcnt] += $bcnt;
#$Bcnthmary[$rtcnt][$loopcnt] += $htmlwc;

#print "Bcnthmary $ordernumberis $Bcnthmary[$rtcnt][$loopcnt]\n";

}   # end of for for loopcnt

#$BctIs = $Bcntarry[$rtcnt];
#$TsIs = $TTtsarry[$rtcnt];
#$hmary = \@Bcnthmary;

#&prtsums($rtcnt, $BctIs, $TsIs, $hmary, $stinp, $dateIs, $wdir);

return 0;

}   # end of sub process_inp



###############################################################################
#   parse the input arguments, and return the argument as html link file
#
##############################################################################

sub parseargv {

  if ($#ARGV >= 0) {
    foreach $argnum (0 .. $#ARGV) {
     $ipArg = $ARGV[$argnum];
     $ipArg =~ s/^\s+|\s+$//g;     # trim leading and tailinig spaces
    }  # end of foreach
  }  # end of if ARGV


if (length($ipArg)>0) { 
  $hmf = $ARGV[0];
} else {
  $hmf = "./aFile";
}

#$localyes = $ARGV[1];

$ainfo = $hmf.",".$localyes;
#$ainfo = $hmf;

return $ainfo;

}

###############################################################################
#   get the order number from an input string  h?h?h?
#
##############################################################################

sub getorderno {

local($ordinp, $lpcnt) = @_;
$odin = $ordinp;

@inpstr=();
@inpstr = split(/h/,$odin);  
#note:$inpstr[0] is an empty string
shift @inpstr;   # first empty element is eliminated

$ordernois = $inpstr[$lpcnt];

#print "\nordernois $ordernois \n";

#get the substring as the link order number
#$chrno1 = ($loopcnt*2)+1;
#$chrno2 = 1;   # 1 length
#$odin =~ s/^\s+|\s+$//g;     # trim leading and tailinig spaces
#$ordernois = substr($odin,$chrno1,$chrno2);

return $ordernois;

}


###############################################################################
#   Tailor the found string  and return it
#         for example,   www.richpuppy.net/AutomtTest/Cola.html
#
###############################################################################
sub obtainstr {

    local($strfound) = @_;
    my @arr = ();

    @arr = split(/\s+/,$strfound);

    my $lastelement =  $arr[$#arr];

    if ($lastelement =~ /http:\/\/(.*?\.html)/)  {  
       $stringobtained = $1;
    } elsif ($lastelement =~ /\"\s*\/\/(.*?\.html)/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /\"\s*(\/.*?\.html)/)  { # for sinica site
       $stringobtained = $1;
    }

    if (length($stringobtained)==0) {  
       $stringobtained = $lastelement;
    }

    return $stringobtained;
}

