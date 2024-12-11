use feature qw(say);
use DateTime;
use threads;

use warnings;
use strict;

my $filename = 'resource/day11/test.txt';
my @input;
my $counter=0;
my $max_counter=25;

open(FH, '<', $filename) or die $!;

while(<FH>){
   $input[$counter]=$_;
   $counter++;
}

close(FH);

my $sum = 0;

my $datetime = localtime();   
say "Local Time of the System : $datetime\n";
for my $c (split ' ', $input[0]) {

   my $res = Blink($c, 0);
   say("Result for: " . $c . " is: " . $res);
   $sum += $res;
   $datetime = localtime();
   say "Local Time of the System : $datetime\n";

}

say($sum);

sub Blink {
   my ($stone, $counter) = @_; 
   if($counter == $max_counter){ 

      return 1;
   }
   $stone = RemoveLeadingZeros($stone);
   $counter++;
   if($stone == "0"){
      return Blink("1", $counter);
   } elsif (length($stone) %2 == 0){
      return Blink(substr( $stone, 0, length($stone) / 2 ), $counter) + Blink(substr($stone, length($stone) / 2), $counter);
   } else {
      return Blink(2024 * $stone, $counter);
   }
}

sub RemoveLeadingZeros {
   my ($str) = @_;
   while(substr($str, 0, 1) eq "0"){
      $str = substr($str, 1);
   }
   if(length($str) == 0){
      return "0";
   }
   return $str;
}