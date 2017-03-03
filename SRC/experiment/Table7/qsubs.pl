###############################################################################
#   Parse the html source code to get .html links 
#   An array aryhmf is to be returned at end of the function
#    --  for iis.sinica site
###############################################################################

sub parsehtml  {

   local($hmf, $urlr) = @_;

   $linkcnt = 0;

   @aryhmf = ();

   my $urlup = "";
   my $urlroot = $urlr; 
   #my $urlroot = "http://www.iis.sinica.edu.tw/";

   ##  deal with ../
   @urlary = split(/\//, $urlroot);  
   pop @urlary; 
 
   #for ($i=0; $i<=$#urlary; $i++) {   
   #  print "urlary i = $i $urlary[$i]\n"; 
   #  if ($i>0) {   $urlup .= $urlary[$i]."/";  } 
   #  else {   $urlup = $urlary[$i];  }
   #}
 
   foreach $a (@urlary) {  
       $urlup .= $a."/";
   }

   open(HTMLIN, $hmf) || die ("couldn't open file $hmf");


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

     if (($obtainstr1 =~ /http/) || ($obtainstr1 =~ /sinica/)) { 
       if ($obtainstr1 != /\/\/\w+www/) {
         $aryhmf[$linkcnt] = $obtainstr1; 
         $linkcnt++;
       }
     }  else  {
       if (($obtainstr1 =~ /^\/(.*)$/)) {
         $aryhmf[$linkcnt] = $urlroot.$1;
         $linkcnt++;
       }  else  {
         $aryhmf[$linkcnt] = $urlroot.$obtainstr1;
         $linkcnt++;
       }
     }
     #print "\nobtainstr1 :  $obtainstr1\n";
     #print "urlroot $urlroot \n";
     #print "1: linkcnt $linkcnt aryhmf[$linkcnt] : $aryhmf[$linkcnt]\n";

     #if ($linkcnt==500) { last; }

     #if ($secondString =~ /(\/.*?\/.*?\.html)$/) {
     if ($secondString1 =~ /A.*?href(.*?\.html)(.*)$/i) {

        $stringFound2 = $1;
        $secondString2 = $2;

        $obtainstr2 = &obtainstr($stringFound2);

     if (($obtainstr2 =~ /http/) || ($obtainstr2 =~ /sinica/)) {
       if ($obtainstr2 != /\/\/\w+www/) {
         $aryhmf[$linkcnt] = $obtainstr2;
         $linkcnt++; 
       }
     }  else  {
       if (($obtainstr2 =~ /^\/(.*)$/)) {
         $aryhmf[$linkcnt] = $urlroot.$1;
         $linkcnt++;
       }  else  {
         $aryhmf[$linkcnt] = $urlroot.$obtainstr2;
         $linkcnt++;
       }
     }

        #print "\n2: linkcnt $linkcnt aryhmf[linkcnt] : $aryhmf[$linkcnt]\n";

        #if ($linkcnt==500) { last; }

        if ($secondString2 =~  /A.*?href(.*?\.html)(.*)$/i) {

           $stringFound3 = $1;
           $secondString3 = $2;

        $obtainstr3 = &obtainstr($stringFound3);

        if (($obtainstr3 =~ /http/) || ($obtainstr3 =~ /sinica/)) {
          if ($obtainstr3 != /\/\/\w+www/) {
            $aryhmf[$linkcnt] = $obtainstr3; 
            $linkcnt++;
          }
        }  else  {
          if (($obtainstr3 =~ /^\/(.*)$/)) {
            $aryhmf[$linkcnt] = $urlroot.$1;
            $linkcnt++;
          }  else  {
            $aryhmf[$linkcnt] = $urlroot.$obtainstr3;
            $linkcnt++;
          }              
        }

           #print "3: \nlinkcnt:$linkcnt aryhmf[linkcnt] : $aryhmf[$linkcnt]\n";
           #if ($linkcnt==500) { last; }
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
#         for example,    
#   http://www.iis.sinica.edu.tw/page/research/ProgrammingLanguagesandFormalMethods.html 
#     --  for iis.sinica  site
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

###############################################################################
#   Parse the html source code to get .html links    
#   An array aryhmf is to be returned at end of the function
#    --  for puppy site
###############################################################################

sub parsehtml_puppy  {
 
   local($hmf, $urlr) = @_;

   $linkcnt = 0;

   @aryhmf = ();

   open(HTMLIN, $hmf) || die ("couldn't open file $hmf"); 

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
 
     $obtainstr1 = &obtainstr_puppy($stringFound1);
    
     if ($obtainstr1 =~ /richpuppy/) {
       $aryhmf[$linkcnt] = $obtainstr1;
       #print "yes obtainstr1 $obtainstr1 aryhmf $linkcnt $aryhmf[$linkcnt] \n";
     }  else  { 
       $aryhmf[$linkcnt] = $urlroot.$obtainstr1;
       #print "else 1: aryhmf $linkcnt $aryhmf[$linkcnt] \n";
     }

     #print "obtainstr1 $obtainstr1 aryhmf $aryhmf[$linkcnt] \n"; 

     $linkcnt++;
     #if ($linkcnt==500) { last; } 

     #if ($secondString =~ /(\/.*?\/.*?\.html)$/) {
     if ($secondString1 =~ /A.*?(http.*?\.html)(.*)$/i) {

        $stringFound2 = $1;
        $secondString2 = $2;

        $obtainstr2 = &obtainstr_puppy($stringFound2);

        if ($obtainstr2 =~ /richpuppy/) {
          $aryhmf[$linkcnt] = $obtainstr2;
          #print "yes obtainstr2 $obtainstr2 aryhmf $aryhmf[$linkcnt] \n";
        }  else  {
          $aryhmf[$linkcnt] = $urlroot.$obtainstr2;
          #print "else 2: aryhmf $aryhmf[$linkcnt] \n";
        }

        $linkcnt++;
        #if ($linkcnt==500) { last; }

        if ($secondString2 =~  /A.*?(http.*?\.html)(.*)$/i) {

           $stringFound3 = $1;
           $secondString3 = $2;

           $obtainstr3 = &obtainstr_puppy($stringFound3);

        if ($obtainstr3 =~ /richpuppy/) {
           $aryhmf[$linkcnt] = $obtainstr3;
           #print "yes obtainstr3 $obtainstr3 aryhmf $aryhmf[$linkcnt] \n";
        }  else  {
           $aryhmf[$linkcnt] = $urlroot.$obtainstr3;
           #print "3: aryhmf $aryhmf[$linkcnt] \n";
        }

           $linkcnt++;
           #if ($linkcnt==500) { last; }
         }
     }
   }

}   # end of while HTMLIN
close(HTMLIN);

   return @aryhmf;

}  # end of sub  parsehtml_puppy

###############################################################################
#   Tailor the found string  and return it
#         for example,   www.richpuppy.net/AutomtTest/index.html
#     -- for puppy site
###############################################################################

sub obtainstr_puppy {

    local($strfound) = @_;
    my @arr = ();

    @arr = split(/\s+/,$strfound);

    my $lastelement =  $arr[$#arr];

    if ($lastelement =~ /http:\/\/(.*?\.html)/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /\"\s*\/\/(.*?\.html)/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /\"\s*\/(.*?\.html)/)  { 
       $stringobtained = $1;
    }

    if (length($stringobtained)==0) {
       $stringobtained = $lastelement;
    }

    return $stringobtained;
}


###############################################################################
#   Parse the html source code to get .html links    
#   An array aryhmf is to be returned at end of the function
#     --  for ntu site
###############################################################################

sub parsehtml_ntu  {
 
   local($hmf, $urlr) = @_;

   $linkcnt = 0;

   my @aryhmf = ();
   my $urlup = "";
   my $urlroot = $urlr; 
   my $filtero = 0;

   #my $urlorg = "http://www.ntu.edu.tw/english/";
   #the following is for a specific site 
   #my $urlroot = "http://www.ntu.edu.tw/english/";

   ##  deal with ../
   @urlary = split(/\//, $urlroot);  
   pop @urlary; 
 
   #for ($i=0; $i<=$#urlary; $i++) {   
   #  print "urlary i = $i $urlary[$i]\n"; 
   #  if ($i>0) {   $urlup .= $urlary[$i]."/";  } 
   #  else {   $urlup = $urlary[$i];  }
   #}
 
   foreach $a (@urlary) {  
     $urlup .= $a."/";
     #$urlup = "http://www.ntu.edu.tw/";
   }
   
   #print "\n\n parsehtml_ntu count:$#urlary urlroot=$urlroot urlup = $urlup\n"; 

open(HTMLIN, $hmf) || die ("couldn't open file $hmf"); 
 
while (<HTMLIN>) { 
   chop;   
 
   #first html site by having two .html 
   #if ($htmltoparse =~ /href.*?\s*http\:\/\/(.*?\.html)(.*?\.html)(.*)/)
   #if ($_ =~ /href.*?\s*http\:\/\/(.*?\.html)(.*?\.html)(.*)/)
   #if ($_ =~ /A.*?HREF(.*?\.html)(.*)/i)     
   #if ($_ =~ /A.*?(http.*?\.html)(.*)$/i)
   #if ($_ =~ /A.*?href(.*?\.html)(.*)$/i)
   if ($_ =~ /a.*?href(.*?\.html)(.*)$/i)
   {  
     $stringFound1 = $1; 
     $secondString1 = $2;
    
     if ($stringFound1 !~ /\w+/)  { 
#print " stringFound1 has possibly no characters"; 
       next; 
     } 

     $obtainstr1 = &obtainstr_ntu($stringFound1);

     $filtero = &yes2filter($obtainstr1); 

     #print "linkcnt $linkcnt filtero:$filtero urlroot=$urlroot  obtainstr1=$obtainstr1  stringFound1 $stringFound1    secondString1  $secondString1 \n";

     #if ($filtero) {  
     #   $linkcnt--;
     #}  else { 
     if (!$filtero) {  
      if (($obtainstr1 =~ /http/) || ($obtainstr1 =~ /ntu/)) {
        $aryhmf[$linkcnt] = $obtainstr1; 
      }  elsif ($obtainstr1 =~ /\.\.\/(.*?\.html)/)  {   
        #print "obtainstr1 to array $urlup$1\n";
        $aryhmf[$linkcnt] = $urlup.$1; 
      }  else {
        #print "else obtainstr1 to array $urlroot$obtainstr1\n";
        $aryhmf[$linkcnt] = $urlroot.$obtainstr1;
      }   
     #print "\nobtainstr1 :  $obtainstr1\n";
     #print "\n1: aryhmf[$linkcnt] : $aryhmf[$linkcnt]\n";  
      $linkcnt++;
     }

     #if ($linkcnt==500) { last; } 
     $filtero = 0;

     #if ($secondString =~ /(\/.*?\/.*?\.html)$/) {
     if ($secondString1 =~ /a.*?href(.*?\.html)(.*)$/i) {

        $stringFound2 = $1;
        $secondString2 = $2;

        $obtainstr2 = &obtainstr_ntu($stringFound2);
        
        $filtero = &yes2filter($obtainstr2); 

     if (!$filtero) {  
       if (($obtainstr2 =~ /http/) || ($obtainstr2 =~ /ntu/)) {
         $aryhmf[$linkcnt] = $obtainstr2;
       }  elsif ($obtainstr2 =~ /\.\.\/(.*?\.html)/)  {
         $aryhmf[$linkcnt] = $urlup.$1;
       }  else {
         $aryhmf[$linkcnt] = $urlroot.$obtainstr2;
       } 
       $linkcnt++;
     }

        #print "\n2: linkcnt $linkcnt aryhmf[linkcnt] : $aryhmf[$linkcnt]\n"; 

        #if ($linkcnt==500) { last; }
        $filtero = 0;

        if ($secondString2 =~  /a.*?href(.*?\.html)(.*)$/i) {

           $stringFound3 = $1;
           $secondString3 = $2;

        $obtainstr3 = &obtainstr_ntu($stringFound3);
        
        $filtero = &yes2filter($obtainstr3); 

     if (!$filtero) {  
       if (($obtainstr3 =~ /http/) || ($obtainstr3 =~ /ntu/)) {
         $aryhmf[$linkcnt] = $obtainstr3;
       }  elsif ($obtainstr3 =~ /\.\.(\/.*?\.html)/)  {
         $aryhmf[$linkcnt] = $urlup.$1;
       }  else {
         $aryhmf[$linkcnt] = $urlroot.$obtainstr3;
       }
       $linkcnt++;
     }
           #print "3: \naryhmf[linkcnt] : $aryhmf[$linkcnt]\n"; 

           #if ($linkcnt==500) { last; }
         }
     } 

     #print "obtainstrs: 1: $obtainstr1  2: $obtainstr2  3: $obtainstr3\n"; 
   }

 }   # end of while HTMLIN
close(HTMLIN);

   return @aryhmf;

}  # end of sub parsehtml_ntu

  
###############################################################################
#   Tailor the found string  and return it
#         for example,  http://www.ntu.edu.tw/english
#     --  for ntu site 
###############################################################################

sub obtainstr_ntu {

    local($strfound) = @_;
    my @arr = ();

#print "\b********** sub obtainstr  input $strfound \n";

    $strfound =~ s/^\s+|\s+$//g;     # trim leading and tailing spaces

    @arr = split(/\s+/,$strfound);

#foreach $a (@arr) {
#  print "sub obtainstr each $a\n"
#}
    
    #my $lastelement =  $arr[$#arr];
    my $lastelement =  $arr[0];

    if ($lastelement =~ /(http:\/\/.*?\.html)/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /"(http\S\/\/.*?)"/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /"\s*(.*?\.html)/)  { 
       $stringobtained = $1;
    } elsif ($lastelement =~ /="\s*(.*?\.html)/)  { 
       $stringobtained = $1;
    }

    if (length($stringobtained)==0) {
       $stringobtained = $lastelement;
    }

    #print "sub stringobtained $stringobtained\n";

    return $stringobtained;
}

###############################################################################
#   Parse the html source code to get .html links    
#   An array aryhmf is to be returned at end of the function
#     --  for utexas site
###############################################################################

sub parsehtml_ut {
 
   local($hmf, $urlr) = @_;

   my $linkcnt = 0;

   my @aryhmf = ();
   my $urlup = "";
   my $urlroot = $urlr; 

   #the following is for a specific site 
   #my $urlroot = "http://www.ntu.edu.tw/english/";

   ##  deal with ../
   @urlary = split(/\//, $urlroot);  
   pop @urlary; 
 
   #for ($i=0; $i<=$#urlary; $i++) {   
   #  print "urlary i = $i $urlary[$i]\n"; 
   #  if ($i>0) {   $urlup .= $urlary[$i]."/";  } 
   #  else {   $urlup = $urlary[$i];  }
   #}
 
   foreach $a (@urlary) {  
     $urlup .= $a."/";
   }
   
   #print "\n\n parsehtml_ut count:$#urlary urlroot=$urlroot urlup = $urlup\n"; 

open(HTMLIN, $hmf) || die ("couldn't open file $hmf"); 
 
while (<HTMLIN>) { 
   chop;   
 
   #first html site by having two .html 
   #if ($htmltoparse =~ /href.*?\s*http\:\/\/(.*?\.html)(.*?\.html)(.*)/)
   #if ($_ =~ /href.*?\s*http\:\/\/(.*?\.html)(.*?\.html)(.*)/)
   #if ($_ =~ /A.*?HREF(.*?\.html)(.*)/i)     
   #if ($_ =~ /A.*?(http.*?\.html)(.*)$/i)
   #if ($_ =~ /A.*?href(.*?\.html)(.*)$/i)
   #if ($_ =~ /a.*?href(.*?\.html)(.*)$/i)
   #if ($_ =~ /a\s+href(.*?)"(.*)$/i)
   if ($_ =~ /a.*?href(.*)?"/i)
   {  
     $stringFound1 = $1; 
     $secondString1 = $2;
    
     if ($stringFound1 !~ /\w+/)  { 
      #print " stringFound1 has no characters\n"; 
      next; 
     } 

     $obtainstr1 = &obtainstr_ut($stringFound1);
   
     #print "urlroot=$urlroot  obtainstr1=$obtainstr1  stringFound1 $stringFound1    secondString1  $secondString1 \n";

     if (($obtainstr1 =~ /http/) || ($obtainstr1 =~ /utexas/)) {
        $aryhmf[$linkcnt] = $obtainstr1; 
     }  elsif ($obtainstr1 =~ /\.\.\/(.*?\.html)/)  {   
        #print "obtainstr1 to array $urlup$1\n";
        $aryhmf[$linkcnt] = $urlup.$1; 
     }  else {
        #print "else obtainstr1 to array $urlroot$obtainstr1\n";
        $aryhmf[$linkcnt] = $urlroot.$obtainstr1;
     }  
     #print "\nobtainstr1 :  $obtainstr1\n";
     #print "\n1: aryhmf[$linkcnt] : $aryhmf[$linkcnt]\n";  

     $linkcnt++;
     #if ($linkcnt==500) { last; } 

     if ($secondString1 =~ /a.*?href(.*?\.html)(.*)$/i) {

        $stringFound2 = $1;
        $secondString2 = $2;

        $obtainstr2 = &obtainstr_ut($stringFound2);

     if (($obtainstr2 =~ /http/) || ($obtainstr2 =~ /utexas/)) {
       $aryhmf[$linkcnt] = $obtainstr2;
     }  elsif ($obtainstr2 =~ /\.\.\/(.*?\.html)/)  {
       $aryhmf[$linkcnt] = $urlup.$1;
     }  else {
       $aryhmf[$linkcnt] = $urlroot.$obtainstr2;
     }

        #print "\n2: linkcnt $linkcnt aryhmf[linkcnt] : $aryhmf[$linkcnt]\n"; 

        $linkcnt++;
        #if ($linkcnt==500) { last; }

        if ($secondString2 =~  /a.*?href(.*?\.html)(.*)$/i) {

           $stringFound3 = $1;
           $secondString3 = $2;

     if (($obtainstr3 =~ /http/) || ($obtainstr3 =~ /utexas/)) {
       $aryhmf[$linkcnt] = $obtainstr3;
     }  elsif ($obtainstr3 =~ /\.\.(\/.*?\.html)/)  {
       $aryhmf[$linkcnt] = $urlup.$1;
     }  else {
       $aryhmf[$linkcnt] = $urlroot.$obtainstr3;
     }

           #print "3: \naryhmf[linkcnt] : $aryhmf[$linkcnt]\n"; 

           $linkcnt++;
           #if ($linkcnt==500) { last; }
         }
     } 

     #print "obtainstrs: 1: $obtainstr1  2: $obtainstr2  3: $obtainstr3\n"; 
   }

 }   # end of while HTMLIN
close(HTMLIN);

   return @aryhmf;

}  # end of sub parsehtml_ut

  
###############################################################################
#   Tailor the found string  and return it
#         for example,  http://www.stanford.edu/english 
#  http://www.utexas.edu/academics/cockrell-school-of-engineering
#     --  for utexas site 
###############################################################################

sub obtainstr_ut {

    local($strfound) = @_;
    my @arr = ();

#print "\b********** sub obtainstr  input $strfound \n";

    $strfound =~ s/^\s+|\s+$//g;     # trim leading and tailing spaces

    @arr = split(/\s+/,$strfound);

#foreach $a (@arr) {
#  print "sub obtainstr each $a\n"
#}
    
    #my $lastelement =  $arr[$#arr];
    my $lastelement =  $arr[0];

    if ($lastelement =~ /(http:\/\/.*?\.html)/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /"(http\S\/\/.*?)"/)  {
       $stringobtained = $1;
    } elsif ($lastelement =~ /"\s*(.*?\.html)/)  { 
       $stringobtained = $1;
    } elsif ($lastelement =~ /="\s*(.*?\.html)/)  { 
       $stringobtained = $1;
    }

    if (length($stringobtained)==0) {
       $stringobtained = $lastelement;
    }

    #print "sub stringobtained $stringobtained\n";

    return $stringobtained; 

}

###############################################################################
#
#   if an obtained string contains string that needs to be filtered, return true   
#
###############################################################################
sub yes2filter {

  local($obtstr) = @_;

  my $flto = 0;

  my @filterout = ("facebook", "twitter", ".png", ".org", ".gov", "cgi-bin", "CIS", "m.ntu", "news", "spotlight", "statistics","event", "rusen", "research", "academics", "sitemap", "donation");

  foreach $case (@filterout) { 
    if ($obtstr =~ /$case/i)  {
       #print "$case is in obtstr\n"; 
       $flto = 1;
       last;
    }
  }  

  return $flto;
}

###############################################################################
#
#   print array  data  
#
###############################################################################
sub ary2file {

  local($aryf, $fileIs)  = @_;

  $outps = "> ".$fileIs;

  open(TOFILE, $outps) || die ("couldn't open file $outps");

  foreach $a (@{$aryf}) {
    print TOFILE "$a\n";
  }

  close(TOFILE);
}

1;
