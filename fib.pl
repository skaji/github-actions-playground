#!/usr/bin/env perl
use strict;
use warnings;

use Time::HiRes qw(gettimeofday tv_interval);

sub fib {
    my $n = shift;
    if ($n == 0 || $n == 1) {
        return 1;
    }
    fib($n - 1) + fib($n - 2);
}

$|++;

my $t0 = [gettimeofday];
for my $n (30..38) {
    my $fib = fib($n);
    my $t1 = [gettimeofday];
    my $elapsed = tv_interval $t0, $t1;
    printf "%6.3fsec  fib(%d) = %d\n", $elapsed, $n, $fib;
    $t0 = $t1;
}
