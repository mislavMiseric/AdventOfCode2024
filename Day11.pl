#!/usr/bin/perl
use warnings;
use strict;

my $filename = 'resource/day11/test.txt';

open(FH, '<', $filename) or die $!;

while(<FH>){
   print $_;
}

close(FH);