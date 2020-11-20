#!/usr/bin/env perl
use strict;
use warnings;

my @module = qw(
    LWP
    IO::Socket::SSL
    Net::SSLeay
    version
    File::Copy
    File::Spec
    Cwd
    HTTP::Tiny
);

for my $module (@module) {
    warn "-> require $module\n";
    my $ok = !system $^X, "-M$module", "-e1";
    warn $ok ? "OK" : "NG", "\n";
}

exit 0;
