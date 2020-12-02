#!/usr/bin/env perl
use strict;
use warnings;

use HTTP::Tiny;

print "$^V $^X\n";

my $res = HTTP::Tiny->new->get("https://github.com");
print "$res->{status} $res->{reason}\n";
print $res->{content} if $res->{status} == 599;
