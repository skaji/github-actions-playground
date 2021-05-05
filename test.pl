#!/usr/bin/env perl
use strict;
use warnings;
use HTTP::Tiny;
use IO::Socket::SSL;

system 'perl -MWin32 -E "say Win32->VERSION"';



my $res = HTTP::Tiny->new->mirror(
    "https://cpan.metacpan.org/authors/id/J/JD/JDB/Win32-0.57.tar.gz",
    "Win32-0.57.tar.gz",
);

die $res->{status} if !$res->{success};

!system "tar xf Win32-0.57.tar.gz" or die;

chdir "Win32-0.57" or die;

system "perl Makefile.PL";
warn "-> \$? = $?\n";

if (-f "Makefile") {
    warn "Found Makefile";
} else {
    warn "NOT found Makefile";
}

system "gmake";
warn "-> \$? = $?\n";



