#!/usr/bin/env perl
use strict;
use warnings;
use feature 'say';

use Config;
use HTTP::Daemon;
use HTTP::Response;
use HTTP::Tiny;
use Socket ();
use Sys::Hostname ();

{   # hotfix
    no warnings 'redefine';
    *HTTP::Daemon::url = sub {
        my $self = shift;

        my $host = $self->sockhost;
        $host = '127.0.0.1' if $host eq '0.0.0.0';
        $host = '::1'       if $host eq '::';
        $host = "[$host]"   if $self->sockdomain == Socket::AF_INET6;

        my $url = sprintf "%s://%s", $self->_default_scheme, $host;
        my $port = $self->sockport;
        $url .= ":$port" if $port != $self->_default_port;
        $url .= "/";
        $url;
    };
}

sub test {
    my $host = shift;
    say "Create HTTP::Daemon object with LocalHost => ", $host // "undef";
    my $httpd = HTTP::Daemon->new(LocalHost => $host);
    if (!$httpd) {
        say "Fail, $!";
        return;
    }
    my $url = $httpd->url;
    say "\$httpd->url is $url";

    my $pid = fork // die;
    if ($pid == 0) {
        say "Perform HTTP GET $url";
        my $res;
        eval {
            local $SIG{ALRM} = sub { die "alarm\n" };
            alarm 5;
            $res = HTTP::Tiny->new(timeout => 5)->get($url);
        };
        my $err = $@ ? "timeout" : undef;
        alarm 0;
        if ($err) {
            say "Error: $err";
        } else {
            say "$res->{status} $res->{reason}";
            say $res->{content} if $res->{status} == 599;
        }
        exit;
    }

    if (my $c = $httpd->accept) {
        my $req = $c->get_request;
        $c->send_response(HTTP::Response->new(200));
        $c->close;
    }
    $httpd->close;

    wait;
}

$|++;

say "perl $^V $Config{archname}";
for my $class (qw(Socket IO::Socket::IP HTTP::Daemon)) {
    say "$class ", $class->VERSION;
}
say "";

for my $host (undef, qw(localhost 127.0.0.1 ::1), Sys::Hostname::hostname) {
    test $host;
    say "";
}
