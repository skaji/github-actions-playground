#!/usr/bin/env perl
use strict;
use warnings;

use Config;
use IO::Socket::IP;
use JSON::PP ();
use Socket ();
use Sys::Hostname ();

my %RESULT;

$RESULT{version}{perl} = "$^V $Config{archname}";
for my $class (qw(IO::Socket::IP Socket)) {
    $RESULT{version}{$class} = $class->VERSION;
}

for my $const (qw(INADDR_ANY IN6ADDR_ANY INADDR_LOOPBACK IN6ADDR_LOOPBACK AF_INET AF_INET6)) {
    $RESULT{const}{$const} = eval "Socket::$const()";
}

for my $name (qw(localhost localhost4 localhost6), Sys::Hostname::hostname) {
    my @ret = gethostbyname $name;
    $RESULT{dns}{"gethostbyname($name)"} = @ret ? \@ret : "(NO OUTPUT)";

    my $hints = {  protocol => Socket::IPPROTO_TCP, socktype => Socket::SOCK_STREAM };
    my ($err, @addr) = Socket::getaddrinfo $name, "", $hints;
    if ($err) {
        $RESULT{dns}{"getaddrinfo($name)"} = $err;
    } else {
        for my $addr (@addr) {
            my $family = $addr->{family};
            my $unpacked_addr;
            if ($family == Socket::AF_INET) {
                (undef, $unpacked_addr) = Socket::unpack_sockaddr_in $addr->{addr};
            } elsif ($family == Socket::AF_INET6) {
                (undef,  $unpacked_addr) = Socket::unpack_sockaddr_in6 $addr->{addr};
            } else {
                die "unexpected family $family";
            }
            $addr->{unpacked_addr} = $unpacked_addr;
        }
        $RESULT{dns}{"getaddrinfo($name)"} = \@addr;
    }
}

my $server = IO::Socket::IP->new(Listen => 10, Proto => 'tcp') or die $!;

for my $method (qw(sockhost sockport sockhostname sockservice sockaddr sockdomain)) {
    $RESULT{server}{$method} = $server->$method;
}

my $port = $server->sockport;
open my $tempfh, "+>", undef;

my $pid = fork // die;
if ($pid == 0) {
    for my $name (qw(localhost localhost4 localhost6), qw(0.0.0.0 127.0.0.1 :: ::1), Sys::Hostname::hostname) {
        warn "// connecting $name, port $port...\n";
        my $client;
        eval {
            local $SIG{ALRM} = sub { die "alarm\n" };
            alarm 3;
            $client = IO::Socket::IP->new(PeerHost => $name, PeerPort => $port, Proto => 'tcp', Timeout => 2);
        };
        my $err = $@ ? "timeout" : "";
        alarm 0;
        $err = $! if !$client;
        print {$tempfh} "$name\t", $client ? "ok" : "err: $err", "\n";
        close $client if $client;
    }
    close $tempfh;
    exit;
}
wait;

seek $tempfh, 0, 0;
while (my $line = <$tempfh>) {
    chomp $line;
    my ($name, $result) = split /\t/, $line;
    $RESULT{client}{"connect $name"} = $result;
}

my $json = JSON::PP->new->ascii->pretty->canonical->utf8->encode(\%RESULT);
$json =~ s/\x{7f}/\\u007f/g;
print $json;
