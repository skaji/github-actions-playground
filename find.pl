#!/usr/bin/env perl
use strict;
use warnings;

use File::Find;

my $dir = shift || 'D:\a\_actions\shogo82148\actions-setup-perl\v1\scripts\lib';

find sub {
    my $file = $File::Find::name;
    print "$file\n" if $file !~ /\.git/;
}, $dir;

