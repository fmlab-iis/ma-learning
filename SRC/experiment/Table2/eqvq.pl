#!/usr/bin/perl
#
# Equivalence Query
#
# > time perl  eqvq.pl  http://www.iis.sinica.edu.tw/page/computer/BorrowSoftwaresorEquipments.html 5 1
#  or 
# > time perl  eqvq.pl  http://www.iis.sinica.edu.tw/page/research/ProgrammingLanguagesandFormalMethods.html 5 1 &
# > time perl  eqvq.pl  http://www.richpuppy.net/AutomtTest/index.html 5 1 &
# > time perl  eqvq.pl  http://www.ntu.edu.tw/english 5 1   &
# > time perl  eqvq.pl  http://www.stanford.edu/academics 5 1   &
#

#use strict;
#use warnings;
use IO::Handle;
use threads;
use threads::shared;
require './qsubs.pl';

$WebCnt = 0;
$routecnt = 0; 
$totalroutes = 1;  # default total routes
$stopprb = 5;  # default stop probability
$dateIs = `date "+ %m%d%y-%H%M"`;
$dateIs =~ s/^\s+|\s+$//g;     # trim leading and tailing spaces
$wdir = "../webdir_evq";
$soutf = "sumout_eqv";
$fileeq = "file_eqv"; 
$totallkcnt = 0;

our @Maxlk : shared = ();
our @Hstr : shared = (); 
our @Bcntarry : shared = ();
our @TTtsarry : shared = ();
#$hstrref = \@Hstr;

#$allowdepth = 20;  # maximum number of h (links) in one route

# get the first site by reading command argument
$argstr = &parseargv();

@argstr = split(/,/,$argstr); 
$hmfile = $argstr[0];
$totalroutes = int($argstr[1]);
$stopprb = int($argstr[2]); 

if ($hmfile =~ /ntu/) {
  $urlrt = "http://www.ntu.edu.tw/english/";
  $wdir = "../webdir_evq_ntu";
  $stn = "ntu";
} elsif ($hmfile =~ /stanford/) {
  $urlrt = "http://www.stanford.edu/academics/";
  $wdir = "../webdir_evq_stf";
  $stn = "ntu";
} elsif ($hmfile =~ /richpuppy/) {
  $urlrt = "http://www.richpuppy.net/AutomtTest/index.html";
  $wdir = "../webdir_evq_puppy";
  $stn = "puppy";
} else {
  $urlrt = "http://www.iis.sinica.edu.tw/";
  $wdir = "../webdir_evq_iis";
  $stn = "iis";
}

if (!(-e $wdir)) {
    `mkdir $wdir`;
}

# clean files
open(SUMOUT,">"."$wdir/".$soutf ) || die ("couldn't open file $soutf");
print SUMOUT;
close(SUMOUT);

open(FILEEQ,">"."$wdir/".$fileeq) || die ("couldn't open file $fileeq");
print FILEEQ;
close(FILEEQ);

#$hmfile = "./view-source_www.ni.com_example_14493_en_.html";
#$hmfile = "./aFile";

#print "wget  hmfile $hmfile\n";

$srchtmlfname = $wdir."/WW0-R0-h0.htmlsource";

$cmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null"; 

#system("2>&1 $cmd | tee $wdir/wget.log");
`/usr/bin/wget $hmfile -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null`;
$wcode = &wgetcode($cmd);  
#print "wcode = $wcode\n";
$wcnt++;

$j=0;
my $original_running_threads = threads->list(threads::running);
my $thr;
#$scref = \@statecnt;  


#print "sitenm = $sitenm\n";
#print "urlrt = $urlrt\n";

$j=0;
foreach (1..$totalroutes) {
  $thr = threads->create ('process_inp', $j, $urlrt, $stn); 
  $j++;
}

sleep 1 while (threads->list(threads::running) > $original_running_threads);

$thr->join() if ($thr->is_joinable());

for (threads->list) 
{   $_->join() if ($_->is_joinable());
}

my $maxis = 0;
foreach $a (@Maxlk) { 
  $maxis = ($a > $maxis) ? $a : $maxis; 
  #print "after Maxlk  $a \n";
}

&prt2file($maxis, "maxlkno");  
&ary2file(\@Hstr, "file-2");
&ary2file(\@Bcntarry, "bout-2");
&ary2file(\@TTtsarry, "tout-2");


###############################################################################
#  wgetcode,   iterate wget 5 times, and return the error code 
###############################################################################
sub wgetcode { 
  local($cmdis) = @_;

  $wcode = 1000;
  $wcnt = 0;
  if (($wcode != 0) && ($wcnt<5))  {
    $wcode = system("$cmdis");
    # In order to get return code 0-3, the code from system needs to divide by 256
    $rtcode = $wcode / 256;
    #print "wcode = $wcode  rtcode = $rtcode\n";
    $wcnt++;
  } 

  return $rtcode;
}

###############################################################################
#
# get a random number 
# stop probability is passed from command
#
###############################################################################

sub get_rand { 

  local ($maxnum) = @_;

  $r = 1 + int(rand(100));  # r is a random number of  1 - 100

  #print "get_rand stop $stopprb\n";
 
  # $stopprb is a global variable, passed from command argument 
  if ($r <= $stopprb) { $ris = 0; }
  else { $ris = 1 + int(rand($maxnum));   }

  return $ris;
}

###############################################################################
#
#  the main part of operations 
#  global variables: $srchtmlfname, $sitenm
#
###############################################################################

sub process_inp {

local ($rtcnt, $urlr, $stnm) = @_;

my $urlroot = $urlr;
#$Bcntarry[$rtcnt] = 0;
#$TTtsarry[$rtcnt] = 0;
#$Hstr[$rtcnt] = "";
$maxlkcnt = 0;
my $maxlk: shared = 0;
$firstflg = 1;
my @arryhtml = ();

#current path
$curpath = $urlroot;

while(1)   {

@arryhtml = ();

if ($stnm =~ /ntu/) {
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} elsif ($stnm =~ /stf/) { 
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} elsif ($stnm =~ /puppy/) {
  @arryhtml = &parsehtml_puppy($srchtmlfname, $curpath);
} else { 
  @arryhtml = &parsehtml($srchtmlfname, $curpath);
}


$maxlkcnt = $#arryhtml + 1;

#print "rtcnt $rtcnt: maxlkcnt $maxlkcnt\n";

if ($maxlkcnt<=0)  { last; }  # exit for while 

$maxlk = ($maxlkcnt > $maxlk) ? $maxlkcnt : $maxlk;
share($maxlk);
push(@Maxlk, $maxlk);

$ordernumberis = &get_rand($maxlkcnt);
#$ordernumberis = &get_lkno($srchtmlfname);

if (($ordernumberis==0) && ($#Hstr<0)) {  next; }   # if the first element hits stop - loop again
if ($ordernumberis==0)  { last; }     # stop, exit while loop 

$more_h =  "h".$ordernumberis;

$Hstr[$rtcnt] = $Hstr[$rtcnt].$more_h;
#print "$rtcnt $more_h \n";

$hmfile =  $arryhtml[$ordernumberis-1];
$hmfile =~ s/^\s+|\s+$//g;    #trim leading and tailing spaces

$curpath = "";
#get current path
@aryhm = split(/\//,$hmfile);
pop @aryhm; 
foreach $a (@aryhm) {  
  #print "aryhm a=$a ********   ";
  $curpath .= $a."/";
}

#print "\n\ncurpath is $curpath\n";

#$srchtmlfname = "W".$WebCnt."-R".$rtcnt."-h".$ordernumberis."-"."htmlsource";
$srchtmlfname = "R".$rtcnt."-h".$ordernumberis."-W".$WebCnt."-"."htmlsource";
$srchtmlfname = $wdir."/".$srchtmlfname;

#when the web link does not exist
if (!$hmfile) {
#if (length($hmfile)==0) {
   #print "***************  missing link $hmfile $srchtmlfname\n";
   $WebCnt++;
   last;   # exit while loop 
}

#global variable
$WebCnt++;

$asscary{$hmfile} = @arryhtml;

#print "\nwget $srchtmlfname hmfile: $hmfile\n";

$cmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null";

#system("2>&1 $cmd 1>/dev/null 2>/dev/null");
system("2>&1 $cmd | tee $wdir/wget.log 1>/dev/null 2>/dev/null");
$wcode = &wgetcode($cmd);  
#print "wcode = $wcode\n";
$wcnt++;

#get website response time, average 5 times 
$itts = 5;
$ttts = 0;
foreach (1..$itts) { 
  $tts = `LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH /usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;
  #$tts = `/usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;  
  $ttts += $tts; 
} 

#print "$srchtmlfname hmfile $hmfile \n";

$atts = $ttts/$itts;
$TTtsarry[$rtcnt] += $atts;

$wcc = `wc -c $srchtmlfname`;
@wcc = split(/\s+/,$wcc);
$bcnt = $wcc[0];

$Bcntarry[$rtcnt] += $bcnt;
#print "$rtcnt $bcnt\n"

}   # end of while 

#print "rtcnt=$rtcnt   Hstr[rtcnt]=$Hstr[$rtcnt]\n";

$HstrIs = $Hstr[$rtcnt];
$BctIs = $Bcntarry[$rtcnt];
$TsIs = $TTtsarry[$rtcnt];
#$hmary = \@Bcnthmary;
#comment out 7/21 #$Maxlk[$rtcnt] = $maxlk;


#&prtstrs($rtcnt, $HstrIs);
#&prtsums($rtcnt, $BctIs, $TsIs, $stinp, $dateIs);
#&prtmaxlk($maxlk);

}   # end of sub process_inp 


###############################################################################
#
#   print scalar data  
#
###############################################################################
sub prt2file {

  local($dataIs, $fileIs)  = @_;

  $outps = "> ".$fileIs;

  open(TOFILE, $outps) || die ("couldn't open file $outps");

  print TOFILE "$dataIs\n";

  close(TOFILE);

}


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

$stopprob = $ARGV[1];
$totrt = $ARGV[2]; 

#$ainfo = $stopprob.",".$totrt.",".$hmf;
$ainfo = $hmf.",".$totrt.",".$stopprob;

return $ainfo;

}

