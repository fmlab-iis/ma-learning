#!/usr/bin/perl

#######################################################################
# 
# Input:  web site address
# Output: print the .html link count of this site  
#
# Command to run
# > perl  lcnt.pl  http://www.iis.sinica.edu.tw/page/computer/BorrowSoftwaresorEquipments.html 
# > perl  lcnt.pl http://www.iis.sinica.edu.tw/pages/scm/  
#
#######################################################################

require './qsubs.pl';

  if ($#ARGV >= 0) {
    $hmf = $ARGV[0];
  } else {
    $hmf = $urlrt;
  }


$srchtmlfname = "wget-it";
 
#`wget $hmf -O $srchtmlfname -t 7 -w 5 `;
`wget $hmf -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null`;

if ($hmf =~ /ntu/) {
  $urlrt = "http://www.ntu.edu.tw/english/";
  @arryhtml = &parsehtml_ntu($srchtmlfname, $urlrt);
} elsif ($hmf =~ /utexas/) {
  $urlrt = "http://www.utexas.edu/academics/cockrell-school-of-engineering";
  @arryhtml = &parsehtml_ut($srchtmlfname, $urlrt);
} elsif ($hmf =~ /stanford/) {
  $urlrt = "http://www.stanford.edu/academics/";
  @arryhtml = &parsehtml_ntu($srchtmlfname, $urlrt); 
} elsif ($hmf =~ /puppy/) {
  $urlrt = "http://www.richpuppy.net/AutomtTest/";
  @arryhtml = &parsehtml_puppy($srchtmlfname, $urlrt);
} elsif ($hmf =~ /scm/) {
  $urlrt = "http://www.iis.sinica.edu.tw/pages/scm/";
  @arryhtml = &parsehtml($srchtmlfname, $urlrt);
} else {
  $urlrt = "http://www.iis.sinica.edu.tw/";
  @arryhtml = &parsehtml($srchtmlfname, $urlrt);
}

#print "hmf $hmf\n"; 
#print "urlrt $urlrt\n";

$maxlkcnt = $#arryhtml + 1;

`rm $srchtmlfname`;

print "$maxlkcnt\n";
#return $maxlkcnt; 

