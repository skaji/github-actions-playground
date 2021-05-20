use strict;
use warnings;

my @a;
push @a, q[print "0\x0d\x0a"];
push @a, q[print "1\x0a"];
push @a, q[print "2\x0d"];

my $x = <<'EOF';
print "3\n";
EOF
push @a, $x;

my $y = <<'EOF';
print "4\n";
EOF
push @a, $y;

push @a, "say q(5)";
push @a, "say q('6)";
push @a, q[say q("7)];
push @a, q[say q(\8)];

for my $i (0 .. $#a) {
    print "[$a[$i]]\n";
    print "[$i] START\n";
    system $^X, "-E", $a[$i];
    print "[$i] END\n";
}
