use feature qw(say);
use DateTime;

use warnings;
use strict;

my $filename = 'resource/day11/test.txt';
my $input;
my $max_counter=75;

open(FH, '<', $filename) or die $!;

while(<FH>){
    $input=$_;
}

close(FH);

my $sum = 0;
my $counter = 0;

my $datetime = localtime();   
say "Local Time of the System : $datetime\n";
for my $c (split ' ', $input) {

    my %map = ( $c => 1 );
    $counter = 0;

    while($counter < $max_counter){
        $counter++;
        my %tmpMap = ();
        while ( my ($k, $v) = each %map ) {
            if($k == 0){
                $tmpMap{1}+=$v;
            } elsif (length($k) %2 == 0){
                $tmpMap{substr($k, 0, length($k) / 2 )}+=$v;
                $tmpMap{substr($k, length($k) / 2) + 0}+=$v;
            } else {
                $tmpMap{2024 * $k} += $v;
            }
        }
        %map = %tmpMap;
    }

    my $res = 0;

    foreach my $val (values %map) { 
        $res += $val;
    }


    say("Result for: " . $c . " is: " . $res);
    $sum += $res;
    $datetime = localtime();
    say "Local Time of the System : $datetime\n";

}

say($sum);