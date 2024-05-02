use strict;
use warnings;

$|++;

if (@ARGV and $ARGV[0] eq "test") {
    printf "test: PERL4LIB length is %d\n", length( $ENV{PERL4LIB} || "");
    printf "test: PATH length is %d\n", length $ENV{PATH};
    exit;
}

my $sep  = $^O =~ /win/i ? ";" : ":";
my $path = $^O =~ /win/i ? 'C:\\Windows\\system32' : '/usr/bin';


print "--- PERL4LIB\n";
for my $i ( 10, 100, 1_000, 10_000, 20_000, 30_000, 40_000, 50_000, 60_000, 100_000 ) {
    local $ENV{PERL4LIB} = join ":", ( "FOO" x $i );
    #local $ENV{PATH} = $ENV{PATH} . $sep . ( join $sep, ( $path x $i ) );

    printf "exec: PERL4LIB length is %d\n", length( $ENV{PERL4LIB} || "");
    printf "exec: PATH length is %d\n", length $ENV{PATH};
    system $^X, $0, "test";
    printf "test: exit $?\n";
}

print "--- PATH\n";
for my $i ( 10, 100, 1_000, 2_000, 3_000, 4_000, 10_000, 20_000, 30_000, 40_000, 50_000, 60_000, 100_000 ) {
    #local $ENV{PERL4LIB} = join ":", ( "FOO" x $i );
    local $ENV{PATH} = $ENV{PATH} . $sep . ( join $sep, ( $path x $i ) );

    printf "exec: PERL4LIB length is %d\n", length( $ENV{PERL4LIB} || "");
    printf "exec: PATH length is %d\n", length $ENV{PATH};
    system $^X, $0, "test";
    printf "test: exit $?\n";
}

print "--- both\n";
for my $i ( 10, 100, 1_000, 10_000, 20_000, 30_000, 40_000, 50_000, 60_000, 100_000 ) {
    local $ENV{PERL4LIB} = join ":", ( "FOO" x $i );
    local $ENV{PATH} = $ENV{PATH} . $sep . ( join $sep, ( $path x $i ) );

    printf "exec: PERL4LIB length is %d\n", length( $ENV{PERL4LIB} || "");
    printf "exec: PATH length is %d\n", length $ENV{PATH};
    system $^X, $0, "test";
    printf "test: exit $?\n";
}
