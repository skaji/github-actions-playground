use strict;
use warnings;
use Capture::Tiny qw(capture);


{
    print "sh cpanm\n";
    my $exit = system "sh", "-c", "cpanm";
    print "EXIT >>>>$exit, $?<<<<\n";
}
{
    print "sh cpanm --unknown\n";
    my $exit = system "sh", "-c", "cpanm --unknown";
    print "EXIT >>>>$exit, $?<<<<\n";
}
{
    print "bash cpanm\n";
    my $exit = system "bash", "-c", "cpanm";
    print "EXIT >>>>$exit, $?<<<<\n";
}
{
    print "bash cpanm --unknown\n";
    my $exit = system "bash", "-c", "cpanm --unknown";
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
