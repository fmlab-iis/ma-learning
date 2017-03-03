#!/usr/bin/perl

#
# missionaries and cannibals
#
# >  perl ms.pl  "h2h3h4"
# >  perl ms.pl  "h1"
# >  perl ms.pl  "h9"
#

my $totalms = 0;
my $totalcb = 0;  
my $availablems = 3;
my $availablecb = 3;
my $elmno = 0;
my $loopcnt = 1;

#while(<MLINP>) { 
#    chop;
#    $inprow = $_;
#    $inprow =~ s/^\s+|\s+$//g;  #trim leading and tailing spaces
#    if (length($inprow)>0) { $arrystates[$i] = $inprow; } 
#    $i++;   
#}

my $inpstr = &parseargv();

@cmbonboat = ("m1", "c1", "m2", "m1c1", "c2", "m3", "m2c1", "m1c2", "c3");
#$inpstr = "h2h3h4";
#$inpstr = "h9";
#$inpstr = "h1";

#print "inpstr $inpstr\n";

@inp=();
@inp = split(/h/,$inpstr);  
#note:$inp[0] is an empty string
shift @inp;   # first empty element is eliminated

$stcnt = $#inp+1;

$loopcnt = 1;
foreach (@inp) {  
  $mcnt = 0;  
  $ccnt = 0;
  #print "-".$_."-"; 
  $elmno = $_;  
  $elmt = $cmbonboat[$elmno-1];
  if ($elmt =~ /m(\d+)/) {
      $mcnt = $1;
  }

  if ($elmt =~ /c(\d+)/) {
      $ccnt = $1;
  }

  #print " $loopcnt elmno $elmno  boat element: ".$cmbonboat[$elmno-1]."--mcnt $mcnt --ccnt $ccnt"."\n";

  if ($loopcnt%2) {  # trip going to destination  
      $availablems = $availablems - $mcnt;
      $availablecb = $availablecb - $ccnt;   
      if (($availablems<0) || ($availablecb<0))  { 
        #print "negative available count at element $elmt\n";   
        # ignore this set, add back the available numbers
        $availablems += $mcnt; 
        $availablecb += $ccnt;   
        next;         # go next loop
      }
      if ($mcnt < $ccnt) { $mcnt = 0; }   # eaten by cannibals on boat 
      $totalms = $totalms + $mcnt;
      $totalcb = $totalcb + $ccnt; 
  }   
  else {  # trip back to shore
      $totalms = $totalms - $mcnt;
      $totalcb = $totalcb - $ccnt; 
      if (($totalms<0) || ($totalcb<0))  { 
        #print "negative $loopcnt totalms: $totalms   totalcb:$totalcb\n";
        # ignore this set, add back the total numbers
        $totalms += $mcnt; 
        $totalcb += $ccnt; 
        next;         # go next loop
      }
      if ($mcnt < $ccnt) { $mcnt = 0; }   # eaten by cannibals on boat
      $availablems = $availablems + $mcnt;
      $availablecb = $availablecb + $ccnt;  
  }   

  if ($totalms < $totalcb)  { $totalms = 0;   
                  # print "ms 0, or eaten by cb on destination\n"; 
  }  # eaten by cb on destination 
  if ($availablems < $availablecb)  { $availablems = 0; }  # eaten by cb on shore

  $loopcnt++;

}   # end of foreach

@inp=();

$total = $totalms + $totalcb;

#print "total number of people on destination are $total \n"; 

#&prt2file($total, "mscbtotal");

print $total;

############################################################
#  parse the input arguments, 
############################################################

sub parseargv {

if ($#ARGV >= 0) {   
  $inps = $ARGV[0];
  # don't use my , otherwise it doesn't go out of if scope
}

return $inps;
}


############################################################
#  print scalar data
############################################################ 

sub prt2file {

  local($dataIs, $fileIs)  = @_;

  $outps = "> ".$fileIs;

  open(TOFILE, $outps) || die ("couldn't open file $outps");

  print TOFILE "$dataIs\n";

  close(TOFILE);

}
