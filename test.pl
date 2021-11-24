use strict;
use warnings;
use Capture::Tiny qw(capture);


{
    print "cpanm\n";
    my $exit = system "cpanm";
    print "EXIT >>>>$exit, $?<<<<\n";
}
{
    print "cpanm --unknown\n";
    my $exit = system "cpanm", "--unknown";
    print "EXIT >>>>$exit, $?<<<<\n";
}


for my $cmd (["cpanm"], ["cpanm", "--unknown"]) {
    print "$cmd\n";
    my ($stdout, $stderr, $exit) = capture {
        system @$cmd;
    };

    print "STDOUT >>>>$stdout<<<<\n";
    print "STDERR >>>>$stderr<<<<\n";
    print "EXIT   >>>>$exit<<<<\n";
}
