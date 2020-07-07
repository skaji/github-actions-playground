#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename ();
use File::Temp ();
use File::Copy ();

my @url = do {
    open my $fh, "<", "url.txt" or die;
    my @line = <$fh>;
    chomp @line;
    @line;
};

warn "-> which curl\n";
system "which", "-a", "curl";
warn "-> curl --version\n";
system "curl", "--version";


for my $url (@url) {
    my $basename = File::Basename::basename $url;
    my $file = "header.txt";
    unlink $file;
    my @cmd = qw(
        curl
        --location
        --silent
        --show-error
        --max-time 60
        --max-redirs 5
        --user-agent HTTP-Tinyish/test
    );
    push @cmd,
        "-z", $basename,
        "-o", $basename,
        "--dump-header", $file,
        "--remote-time",
        $url
    ;
    warn "-> $url\n";
    my $exit = system @cmd;
    if ($exit != 0) {
        open my $fh, "<", $file or die;
        File::Copy::copy($fh, \*STDOUT);
        die;
    }
}

