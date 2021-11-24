use strict;
use warnings;
use Capture::Tiny qw(capture);

my ($stdout, $stderr, $exit) = capture {
    system $^X, "-e", 'for (1..5) { print STDOUT "out $_\n"; print STDERR "err $_\n" } exit 2';
};

print "STDOUT >>>>$stdout<<<<\n";
print "STDERR >>>>$stderr<<<<\n";
print "EXIT   >>>>$exit<<<<\n";
