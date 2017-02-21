#!/usr/bin/perl

#######################################################################
# 
# Input:  web site address
# Output: print the .html link count of this site  
#
# Command to run
# > perl  lcnt.pl  http://www.iis.sinica.edu.tw/page/computer/BorrowSoftwaresorEquipments.html 
#
#######################################################################

$urlrt = "http://www.iis.sinica.edu.tw";

  if ($#ARGV >= 0) {
    $hmf = $ARGV[0];
  } else {
    $hmf = $urlrt;
  }

#print "hmf $hmf\n";

$srchtmlfname = "wget-it";
 
#`wget $hmf -O $srchtmlfname -t 7 -w 5 `;
`wget $hmf -O $srchtmlfname -t 7 -w 5 1>/dev/null 2>/dev/null`;

@arryhtml = &parsehtml($srchtmlfname, $urlrt);
$maxlkcnt = $#arryhtml + 1;

`rm $srchtmlfname`;

print "$maxlkcnt\n";
#return $maxlkcnt; 

###############################################################################
#   Parse the html source code to get .html links
#         to 500th link
#   An array aryhmf is to be returned at end of the function
###############################################################################

sub parsehtml  {

   local($hmf, $urlr) = @_;

   $linkcnt = 0;

   @aryhmf = ();

   open(HTMLIN, $hmf) || die ("couldn't open file $hmf");

   #the following is for a specific site
   #my $urlroot = "http://www.iis.sinica.edu.tw";
   my $urlroot = $urlr;

while (<HTMLIN>) {
   chop;

   #first html site by having two .html
   #if ($htmltoparse =~ /href.*?\s*http\:\/\/(.*?\.html)(.*?\.html)(.*)/)
   #if ($_ =~ /href.*?\s*http\:\/\/(.*?\.html)(.*?\.html)(.*)/)
   #if ($_ =~ /A.*?HREF(.*?\.html)(.*)/i)
   #if ($_ =~ /A.*?(http.*?\.html)(.*)$/i)
   if ($_ =~ /A.*?href(.*?\.html)(.*)$/i)
   {
  
     $stringFound1 = $1;
     $secondString1 = $2;

#print "\n********************** stringFound1 = $stringFound1\n";

     $obtainstr1 = &obtainstr($stringFound1);

     if (($obtainstr1 =~ /sinica/)) {
       $aryhmf[$linkcnt] = $obtainstr1;
     }  else  {
       if (($obtainstr1 =~ /^\//)) {
         $aryhmf[$linkcnt] = $urlroot.$obtainstr1;
       }  else  {
         $aryhmf[$linkcnt] = $urlroot."/".$obtainstr1;
       }
     }
     #print "\nobtainstr1 :  $obtainstr1\n";
     #print "1: linkcnt $linkcnt aryhmf[linkcnt] : $aryhmf[$linkcnt]\n";

     $linkcnt++;
     if ($linkcnt==500) { last; }

     #if ($secondString =~ /(\/.*?\/.*?\.html)$/) {
     if ($secondString1 =~ /A.*?(http.*?\.html)(.*)$/i) {

        $stringFound2 = $1;
        $secondString2 = $2;

        $obtainstr2 = &obtainstr($stringFound2);

     if (($obtainstr2 =~ /richpuppy/) || ($obtainstr2 !~ /^\//)) {
       $aryhmf[$linkcnt] = $obtainstr2;
     }  else  {
       $aryhmf[$linkcnt] = $urlroot.$obtainstr2;
     }

        #print "\n2: linkcnt $linkcnt aryhmf[linkcnt] : $aryhmf[$linkcnt]\n";

        $linkcnt++;
        if ($linkcnt==500) { last; }

        if ($secondString2 =~  /A.*?(http.*?\.html)(.*)$/i) {

           $stringFound3 = $1;
           $secondString3 = $2;

     if (($obtainstr3 =~ /richpuppy/) || ($obtainstr3 !~ /^\//)) {
       $aryhmf[$linkcnt] = $obtainstr3;
     }  else  {
       $aryhmf[$linkcnt] = $urlroot.$obtainstr3;
     }

           #print "3: \nlinkcnt:$linkcnt aryhmf[linkcnt] : $aryhmf[$linkcnt]\n"; 

           $linkcnt++;
           if ($linkcnt==500) { last; }
         }
     }

     #print "obtainstrs: 1: $obtainstr1  2: $obtainstr2  3: $obtainstr3\n";
   }

 }   # end of while HTMLIN
close(HTMLIN);

   return @aryhmf;

}  # end of sub  parsehtml

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

#print "lastelement $lastelement\n";

    if ($lastelement =~ /http:\/\/(.*?\.html)/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /\"\s*\/\/(.*?\.html)/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /="\s*(.*?\.html)/)  { # for sinica site
       $stringobtained = $1;
    }
    #} elsif ($lastelement =~ /\"\s*(\/.*?\.html)/)  { # for sinica site

#print "stringobtained $stringobtained\n";

    if (length($stringobtained)==0) {
       $stringobtained = $lastelement;
    }

    return $stringobtained;
}

