#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';
use File::Spec;

say "perl $^V $^X";
say for File::Spec->path;
