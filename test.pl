#!/usr/bin/env perl
use strict;
use warnings;
use IPC::Run3 ();

IPC::Run3::run3 [$^X, "-e", <<'EOF'], undef, undef, undef;
print "Hello, World1!\n";
EOF
print "exit code $?\n";

system $^X, "-e", <<'EOF';
print "Hello, World2!\n";
EOF

print "exit code $?\n";
