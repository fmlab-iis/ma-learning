#!/usr/bin/perl

use threads;

# > time perl mbsq.pl  http://www.iis.sinica.edu.tw/page/computer/BorrowSoftwaresorEquipments.html  &
# > time perl mbsq.pl  http://www.richpuppy.net/AutomtTest/index.html  &   

#use strict;
#use warnings;
use IO::Handle;
use threads;
use threads::shared;
require './qsubs.pl';

$WebCnt = 0;
$loopcnt = 0;
$routecnt = 0;
$acode = 0;
$dateIs = `date "+ %m%d%y-%H%M"`;
$dateIs =~ s/^\s+|\s+$//g;     # trim leading and tailing spaces
$mlinp = "MLoutput";
$wdir = "../webdir_mbq";
$soutf = "sumout"; 
$urlrt = "";

our @Bcntarry : shared = ();
our @TTtsarry : shared = ();

#$hmfile = "./view-source_www.ni.com_example_14493_en_.html";
#$hmfile = "./aFile";

# get the first site by reading command argument
$hmfile = &parseargv();
if ($hmfile =~ /ntu/) {
  $urlrt = "http://www.ntu.edu.tw/english/";  
  $wdir = "../webdir_mbq_ntu";
  $stn = "ntu";
} elsif ($hmfile =~ /stanford/) {
  $urlrt = "http://www.stanford.edu/academics/";
  $wdir = "../webdir_mbq_stf";
  $stn = "ntu";
} elsif ($hmfile =~ /richpuppy/) { 
  $urlrt = "http://www.richpuppy.net/AutomtTest";
  $wdir = "../webdir_mbq_puppy";
  $stn = "puppy";
} else {
  $urlrt = "http://www.iis.sinica.edu.tw/";
  $wdir = "../webdir_mbq_iis";
  $stn = "iis";
}


if (!(-e $wdir)) {
    `mkdir $wdir`;
}

#open(SUMOUT,">"."./".$soutf ) || die ("couldn't open file $soutf"); 
open(SUMOUT,">"."$wdir/".$soutf ) || die ("couldn't open file $soutf"); 
print SUMOUT;
close(SUMOUT);

#my %asscary;

my @arryloop = ();
my @arryroute = ();
@Bcntarry = ();
@Tttsarry = ();


$srchtmlfname = $wdir."/WW0-R0-h0.htmlsource";
`wget $hmfile -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null`;

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

foreach (@inpstr) { 
  #print "-".$_."-";
}

@inpstr=();

#$stcnt = length($stateinp[$routecnt])/2;

$statecnt[$routecnt]=$stcnt;

}   # end of for routecnt

$routesize = $routecnt;

$j=0;
my $original_running_threads = threads->list(threads::running);
my $thr;
$scref = \@statecnt;
foreach (@stateinp) {
  $thr = threads->create ('process_inp', $_, $j, $scref, $urlrt, $stn);
  $j++;  
}

sleep 1 while (threads->list(threads::running) > $original_running_threads);

$thr->join();

for (threads->list) 
{   $_->join();
}

&ary2file(\@Bcntarry, "bout-1");
&ary2file(\@TTtsarry, "tout-1");

#die "The End of the script.  Please enjoy yourself ! ";

###############################################################################
#   read each row of input file, and obtain the next html link 
#
##############################################################################

sub process_inp {

local ($stinp, $rtcnt, $stcref, $urlr, $stnm) = @_;

my @stcntary = @{$stcref};
my $stcnt = $stcntary[$rtcnt];

for ($loopcnt=0; $loopcnt<$stcnt; $loopcnt++) { 

my @arryhtml = (); 
my $urlroot = $urlr;

#print "process_inp $srchtmlfname\n";
 
#@arryhtml = &parsehtml_good($srchtmlfname, $urlroot);

#
if ($stnm =~ /ntu/) {
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} elsif ($stnm =~ /stf/) {
  @arryhtml = &parsehtml_ntu($srchtmlfname, $curpath);
} elsif ($stnm =~ /puppy/) {
  @arryhtml = &parsehtml_puppy($srchtmlfname, $curpath);
} else {
  @arryhtml = &parsehtml($srchtmlfname, $curpath);
}

# get the order number by reading the input string - each row  
$ordernumberis = &getorderno($stinp, $loopcnt);

$hmfile =  $arryhtml[$ordernumberis-1];
$hmfile =~ s/^\s+|\s+$//g;    #trim leading and tailing spaces

$srchtmlfname = "W".$WebCnt."-R".$rtcnt."-h".$ordernumberis."-"."htmlsource";
$srchtmlfname = $wdir."/".$srchtmlfname;

#when the web link does not exist
if (!$hmfile) {
#if (length($hmfile)==0) {
   $Bcntarry[$rtcnt] += 0;
   $TTtsarry[$rtcnt] += 0;
   #print "***************  missing link $hmfile $srchtmlfname\n";
   last;   #out of the loopcnt
}

#global variable
$WebCnt++;

$asscary{$hmfile} = @arryhtml;

$wgetCmd = "/usr/bin/wget $hmfile -O $srchtmlfname -t 7 -w 5";
$wgetrun = system("2>&1 $wgetCmd | tee $wdir/wget.log 1>/dev/null 2>/dev/null");

$tts = `LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH /usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;
#$tts = `/usr/bin/curl -so /dev/null -w '%{time_total}\n' $hmfile`;
#print "\n tts = $tts\n";
$TTtsarry[$rtcnt] += $tts;

$wcc = `wc -c $srchtmlfname`;
@wcc = split(/\s+/,$wcc);
$bcnt = $wcc[0];

$htmlwc=0;
$htmlgrep = `grep "\.html" $srchtmlfname`;
$htmlgot = $htmlgrep;
while ($htmlgot =~ /.*?\.html(.+)/s) {  #including newlines
    $htmlgot = $1;
    $htmlwc++;
    #print "htmlwc: $htmlwc, remaining is $1\n";
    #print "htmlgot: $htmlgot\n";
}

$Bcntarry[$rtcnt] += $bcnt;
$Bcnthmary[$rtcnt][$loopcnt] += $htmlwc;

#print "Bcnthmary $ordernumberis $Bcnthmary[$rtcnt][$loopcnt]\n";

}   # end of for for loopcnt

$BctIs = $Bcntarry[$rtcnt];
$TsIs = $TTtsarry[$rtcnt];
$hmary = \@Bcnthmary;

#&prtsums($rtcnt, $BctIs, $TsIs, $hmary, $stinp, $dateIs, $wdir);

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

return $hmf;

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

$ordernois = $inpstr[$loopcnt];

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

