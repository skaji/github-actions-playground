#!/usr/bin/env perl
use strict;
use warnings;
use IPC::Run3 ();

system $^X, "-MO=Deparse", "-e", "print 1";

print "exit code $?\n";
