#!/usr/bin/perl
#
# Equivalence Query
#
 
# > time perl  eqvqlocal.pl  http://www.ntu.edu.tw/english/index.html 35 50 1  &
# > time perl  eqvqlocal.pl  http://www.richpuppy.net/AutomtTest/index.html 35 50 1 &
# > time perl  eqvq.pl  http://www.iis.sinica.edu.tw/pages/scm/ 35 50 1 &
# > time perl  eqvq.pl  http://www.iis.sinica.edu.tw/page/computer/BorrowSoftwaresorEquipments.html 35 50 1
#  or 
# > time perl  eqvqlocal.pl  http://www.ntu.edu.tw/english/index.html 0 50 1  &
# > time perl  eqvq.pl  http://www.richpuppy.net/AutomtTest/index.html 0 50 1 &
# > time perl  eqvq.pl  http://www.iis.sinica.edu.tw/page/research/ProgrammingLanguagesandFormalMethods.html 0 50 1 &
# > time perl  eqvq.pl  http://tigp.sinica.edu.tw/FAQ.html 0 50 1 &
# > time perl  eqvq.pl  http://www.utexas.edu/academics/cockrell-school-of-engineering 0 50 1 &
# > time perl  eqvq.pl  http://www.stanford.edu/academics 0 50 1  &
# > time perl  eqvq.pl  http://scholar.google.com.tw/intl/en/scholar/help.htm 0 50 1 &
# 
#   If running on Local Host
# > time perl  eqvq.pl  http://www.ntu.edu.tw/english 35 50 1  local&
# > time perl  eqvq.pl  http://www.richpuppy.net/AutomtTest/index.html 35 50 1 local&
# 


#use strict;
#use warnings;
use IO::Handle;
use threads;
use threads::shared;
 
use Time::HiRes qw/time sleep/;
require './qsubs.pl';

$WebCnt = 0;
$routecnt = 0; 
$totalroutes = 1;  # default total routes
$stopprb = 5;  # default stop probability
$dateIs = `date "+ %m%d%y-%H%M"`;
$dateIs =~ s/^\s+|\s+$//g;     # trim leading and tailing spaces
$wdir = "../webdir_evq";
$totallkcnt = 0;
my $curpath = "";
my @aryhm = ();


our @Maxlk : shared = ();
our @Hstr : shared = (); 
our @Bcntarry : shared = ();
our @TTtsarry : shared = ();

#$allowdepth = 20;  # maximum number of h (links) in one route

# get the first site by reading command argument
$argstr = &parseargv();

@argstr = split(/,/,$argstr); 
$hmfile = $argstr[0];
$alphbtsize = int($argstr[1]);
$totalroutes = int($argstr[2]);
$stopprb = int($argstr[3]); 
$localy = $argstr[4];

#print "totalroutes=$totalroutes  stopprb = $stopprb,  localy = $localy\n";
#print "\n wget $srchtmlfname hmfile: $hmfile\n";

if ($hmfile =~ /ntu/) {
  #$urlrt = "http://www.ntu.edu.tw/english/";
  $urlrt = "http://www.ntu.edu.tw/";
  $wdir = "../webdir_evq_ntu";
  #get current path
  @aryhm = split(/\//,$hmfile);
  pop @aryhm;
  foreach $a (@aryhm) {
    #print "aryhm a=$a ********   ";
    $curpath .= $a."/";
  }
  #print "ntu curpath $curpath \n";
  $stn = "ntu";
} elsif ($hmfile =~ /utexas/) {
  $urlrt = "http://www.utexas.edu/academics/cockrell-school-of-engineering";
  $curpath = $urlrt;
  $wdir = "../webdir_evq_ut";
  $stn = "ut";
} elsif ($hmfile =~ /stanford/) {
  $urlrt = "http://www.stanford.edu/academics/";
  $curpath = $urlrt;
  $wdir = "../webdir_evq_stf";
  $stn = "ntu";
} elsif ($hmfile =~ /richpuppy/) {
  $urlrt = "http://www.richpuppy.net/AutomtTest/";
  $curpath = $urlrt;
  $wdir = "../webdir_evq_puppy";
  $stn = "puppy";
} elsif ($hmfile =~ /scm/) {
  $urlrt = "http://www.iis.sinica.edu.tw/pages/scm/";
  $curpath = $urlrt;
  $wdir = "../webdir_evq_iis_scm";
  $stn = "iis";
} elsif ($hmfile =~ /scholar/) {
  $urlrt = "http://scholar.google.com.tw/intl/en/scholar/";
  $curpath = $urlrt;
  $wdir = "../webdir_evq_schl";
  $stn = "ntu";
} elsif ($hmfile =~ /tigp\.sinica/) {
  $urlrt = "http://tigp.sinica.edu.tw/";
  $curpath = $urlrt;
  $wdir = "../webdir_evq_tigp";
  $stn = "iis";
} else {
  $urlrt = "http://www.iis.sinica.edu.tw/";
  $curpath = $urlrt;
  $wdir = "../webdir_evq_iis";
  $stn = "iis";
}

if ($localy =~ /local/) { 
   my $lc = "http://localhost/"; 
   $hmfile =~ s/$urlrt/$lc/i;
   my @arr = split(/\//, $hmfile);
}

if (!(-e $wdir)) {
    `mkdir $wdir`;
}

#$hmfile = "./view-source_www.ni.com_example_14493_en_.html";
#$hmfile = "./aFile";

#print "wget  hmfile $hmfile\n";

$srchtmlfname = $wdir."/WW0-R0-h0.htmlsource";

#$cmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null"; 
$cmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 5 -w 1 1>/dev/null 2>/dev/null"; 

#system("2>&1 $cmd | tee $wdir/wget.log");
`/usr/bin/wget $hmfile -O $srchtmlfname -t 5 -w 1 1>/dev/null 2>/dev/null`;
#$wcode = &wgetcode($cmd);  
#print "wcode = $wcode\n";
#$wcnt++;

my $original_running_threads = threads->list(threads::running);
my $thr;
#$scref = \@statecnt;  

my $j=0;
my $halt = 50;   # the max number of routes before of pause 
foreach (1..$totalroutes) {
  #print "\nbefore process_inp curpath $curpath\n";
  $thr = threads->create ('process_inp', $j, $urlrt, $curpath, $stn, $localy, \@Maxlk, \@Hstr, \@Bcntarry, \@TTtsarry); 
  $j++;
 
  sleep 1;
  # wait 25 seconds to avoid being halt by web access blocking
  #if ($j%$halt==0)  { sleep 1; }   
  #if ($j%$halt==0)  { if ($j>800) { sleep 25; }
  #                    elsif ($j>1000) { sleep 25; }
                      #else { sleep 25; }
  #}
}

sleep 1 while (threads->list(threads::running) > $original_running_threads);

#$thr->join() if ($thr->is_joinable());

for (threads->list) 
{   $_->join() if ($_->is_joinable());
}

my $maxis = 0;

if ($alphbtsize) { 
    $maxis = $alphbtsize;
} else {
  foreach $a (@Maxlk) { 
    $maxis = ($a > $maxis) ? $a : $maxis; 
    #print "after Maxlk  $a \n";
  } 
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
  #$wcnt = 0;
  if (($wcode != 0) && ($wcnt<5))  {
    $wcode = system("$cmdis");
    # In order to get return code 0-3, the code from system needs to divide by 256
    $rtcode = $wcode / 256;
    #print "wcode = $wcode  rtcode = $rtcode\n";
    #$wcnt++;
  } 

  return $rtcode;
}

###############################################################################
#
# get a random number 
# stop probability is passed from command line
#
###############################################################################

sub get_rand { 

  local ($maxnum, $stpb) = @_;

  $r = 1 + int(rand(100));  # r is a random number of  1 - 100

  #print "get_rand stop $stpb\n";
 
  # $stopprb is passed from command argument 
  if ($r <= $stpb) { $ris = 0; }
  else {  $ris = 1 + int(rand($maxnum)); }   

  return $ris;
}

###############################################################################
#
#  the main part of operations 
#  global variables: $srchtmlfname, $sitenm
#
###############################################################################

sub process_inp {

local ($rtcnt, $urlr, $crpth, $stnm, $lcly, $maxf, $hsf, $bcntf, $tttsf) = @_;

my $urlroot = $urlr;
#$Bcntarry[$rtcnt] = 0;
#$TTtsarry[$rtcnt] = 0;
#$Hstr[$rtcnt] = "";
$maxlkcnt = 0;
my $maxlk: shared = 0;
$firstflg = 1;
my @arryhtml = ();
my $lenhselm = 0;
my $curpath = $crpth;
my $urlrt = $urlr;
my @aryhm = ();


while(1)   {

@arryhtml = ();

if ($stnm =~ /ntu/) {
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} elsif ($stnm =~ /puppy/) {
  $curpath = $urlrt;
  @arryhtml = &parsehtml_puppy($srchtmlfname, $curpath);
} elsif ($stnm =~ /ut/) { 
  @arryhtml = &parsehtml_ut($srchtmlfname, $curpath);
} elsif ($stnm =~ /stf/) { 
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} else { 
  $curpath = $urlrt;
  @arryhtml = &parsehtml($srchtmlfname, $curpath);
}

 

if ($alphbtsize) {   $maxlkcnt = $alphbtsize; 
                     $maxlk = $alphbtsize;  
                  } 
else { $maxlkcnt = $#arryhtml + 1; 
       if ($maxlkcnt<=0)  { last; }  # exit for while 
       $maxlk = ($maxlkcnt > $maxlk) ? $maxlkcnt : $maxlk;
 
     }
share($maxlk);
push(@{$maxf}, $maxlk);

$ordernumberis = &get_rand($maxlkcnt, $stopprb);
#$ordernumberis = &get_lkno($srchtmlfname);

$lenhselm = length(@{$hsf}[$rtcnt]);

#print "rtcnt $rtcnt Hstr[rtcnt] length: $lenhselm \n";

if (($ordernumberis==0) && ($lenhselm<=0)) {  next; }   # if the first element hits stop - loop again
if ($ordernumberis==0)  { last; }     # stop, exit while loop 


$more_h =  "h".$ordernumberis;

@{$hsf}[$rtcnt] = @{$hsf}[$rtcnt].$more_h;
#print "$rtcnt @{$hsf}[$rtcnt] \n";

$hmfile =  $arryhtml[$ordernumberis-1];
$hmfile =~ s/^\s+|\s+$//g;    #trim leading and tailing spaces

#if ($hmfile !~ /www\.ntu\.edu\.tw/i) { last; }
#if ($hmfile =~ /http:\/\/m\./i) { last; }     # out of the loop    
#if ($hmfile =~ /statistics/i) { last; }     # out of the loop    
#if ($hmfile =~ /news/i) { last; }     # out of the loop    

#get current path
$curpath = "";
@aryhm = split(/\//,$hmfile);
pop @aryhm; 
foreach $a (@aryhm) {  
  #print "aryhm a=$a ********   ";
  $curpath .= $a."/";
}

#print "\nprocess_inp 2  curpath $curpath hmfile: $hmfile\n";

#$srchtmlfname = "W".$WebCnt."-R".$rtcnt."-h".$ordernumberis."-"."htmlsource";
$srchtmlfname = "R".$rtcnt."-h".$ordernumberis."-W".$WebCnt."-"."htmlsource";
$srchtmlfname = $wdir."/".$srchtmlfname;

if ($lcly =~ /local/) { 
   my $lc = "http://localhost/";

   $hmfile =~ s/$urlrt/$lc/i;

   my @arr = split(/\//, $hmfile);

   #if ($hmfile =~ /\/$/) {  # when ended by /
   #    $hmfile = $urlrt;
       #print "----- ended by / , last arr=$arr[$#arr], hmfile= $hmfile\n";
   #}  else  {  # concatenate the last element
   #    $hmfile = $urlrt.$arr[$#arr]; 
   #}
}

#print "\nwget $srchtmlfname hmfile: $hmfile\n";

#when the web link does not exist
if (!$hmfile) {
#if (length($hmfile)==0) {
   @{$bcntf}[$rtcnt] += 0;
   @{$tttsf}[$rtcnt] += 0;
   #print "***************  missing link $hmfile $srchtmlfname\n";
   $WebCnt++;
   last;   # exit while loop 
}

#global variable
$WebCnt++;

$asscary{$hmfile} = @arryhtml;

$cmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 5 -w 1 1>/dev/null 2>/dev/null";

#system("2>&1 $cmd 1>/dev/null 2>/dev/null");
system("2>&1 $cmd | tee $wdir/wget.log 1>/dev/null 2>/dev/null");
#$wcode = &wgetcode($cmd);  
#print "wcode = $wcode\n";
#$wcnt++;

#get website response time, average 5 times 
$itts = 5;
$ttts = 0;
foreach (1..$itts) { 
  $tts = `LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH /usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;
  #$tts = `/usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;  
  $ttts += $tts; 
} 

#print "$srchtmlfname hmfile $hmfile \n";

# change seconds to milliseconds
$atts = ($ttts*1000)/$itts;
@{$tttsf}[$rtcnt] += $atts;

$wcc = `wc -c $srchtmlfname`;
@wcc = split(/\s+/,$wcc);
$bcnt = $wcc[0];

@{$bcntf}[$rtcnt] += $bcnt;
#print "$rtcnt $bcnt\n"

}   # end of while 

#print "rtcnt=$rtcnt   Hstr[rtcnt]=$Hstr[$rtcnt]\n";

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

$alphbt = $ARGV[1];
$stopprob = $ARGV[2];
$totrt = $ARGV[3]; 
$localyes = $ARGV[3]; 

#$ainfo = $stopprob.",".$totrt.",".$hmf;
$ainfo = $hmf.",".$alphbt.",".$totrt.",".$stopprob.",".$localyes;

return $ainfo;

}

