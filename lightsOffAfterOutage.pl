#!/usr/bin/perl

# This Perl script should run at reboot and checks if all hue lamps are at full brightness (after power outage). If so it will turn them off.

use Fcntl qw(LOCK_EX LOCK_NB);
use File::NFSLock;
use LWP::UserAgent;
use HTTP::Request;
use Net::Ping;
use JSON qw( decode_json );

use strict;
use warnings;

my $lock = File::NFSLock->new($0, LOCK_EX|LOCK_NB);
die "$0 is already running!\n" unless $lock;

# CONFIG
# https://www.developers.meethue.com/documentation/getting-started
my $hueBridgeIP = '192.168.1.x';
my $hueKey = '...';


# APPLICATION

my $useragent = LWP::UserAgent->new;

# check if bridge booted
my $retries = 0;
while ( testIpOnline($hueBridgeIP) < 1 || $retries > 120 ) {
	$retries++;
	print "Waiting for bridge...";
	sleep(2);
}

# request lights status
my $lightStatusRequest = HTTP::Request->new('GET', 'http://'.$hueBridgeIP.'/api/'.$hueKey.'/groups/0');
my $lightStatusResult = $useragent->request($lightStatusRequest);
my $resultLightStatus = decode_json( $lightStatusResult->decoded_content );

# if all lights on
if ($resultLightStatus->{"state"}{"all_on"}) {
	my $turnoffRequest = HTTP::Request->new('PUT', 'http://'.$hueBridgeIP.'/api/'.$hueKey.'/groups/0/action');
	$turnoffRequest->content_type('application/json');
	$turnoffRequest->content('{"on": false}');
	$useragent->request($turnoffRequest);
}


# ping ip
sub testIpOnline {
	my $ip = $_[0];

	print "Checking if ". $ip ." is online...\n";
	my $output = `ping $ip -c 1`;
	if ( index($output, ' 0% packet loss' ) > -1) {
		print $ip." online!\n";
		return 1;
	}
	print $ip ." is not online!\n";

	return 0;
}
