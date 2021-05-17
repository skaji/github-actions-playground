#!/usr/bin/env perl
use strict;
use warnings;

system $^X, "-e", <<'EOF';
print "Hello, World!\n";
EOF

print "exit code $?\n";
