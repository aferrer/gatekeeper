#!/usr/bin/perl

use strict;
use warnings;

use CGI qw/:standard/;

my %services = (
    netcat => 9001,
);

print header(-charset=>'utf-8'),
      start_html("Gatekeeper"),
      h1("Gatekeeper");

if (request_method() eq 'POST') {
    #print map { "$_ => $ENV{$_}<br>\n" } sort keys %ENV;
    printf "port 9001 = %s\n", param("port_9001") eq 'ON' ? 'ON' : 'OFF';
}
else {
    print start_form(),
          p("Which ports should be enabled?");

    for my $service_name (sort keys %services) {
        my $service_port = $services{$service_name};
        print checkbox("port_$service_port", '', 'ON', "$service_name ($service_port)"), "<br>\n";
    }

    print hr(),
          submit(),
          end_form();
}

print end_html();
