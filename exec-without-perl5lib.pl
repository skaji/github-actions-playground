#!/usr/bin/env perl
use strict;
use warnings;

delete $ENV{PERL5LIB};

my $exit = system @_;
exit $exit;
