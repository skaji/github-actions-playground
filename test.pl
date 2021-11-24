use strict;
use warnings;
use Capture::Tiny qw(capture);

for my $cmd (["cpanm"], ["cpanm", "--unknown"]) {
    my ($stdout, $stderr, $exit) = capture {
        system @$cmd;
    };

    print "STDOUT >>>>$stdout<<<<\n";
    print "STDERR >>>>$stderr<<<<\n";
    print "EXIT   >>>>$exit<<<<\n";
}
