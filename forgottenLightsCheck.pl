#!/usr/bin/perl

# This Perl script checks if any of the listed devices is connected to the network
# if not it will turn off all the Phillips Hue lights

# You can disable this behavior by make a file 'disableHue' in the same directory

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

die "Hue automation disabled" if -e "disableHue";

# CONFIG
# https://www.developers.meethue.com/documentation/getting-started
my $hueBridgeIP = '192.168.1.x';
my $hueKey = '...';
my @deviceIPs = ('192.168.1.x','192.168.1.x');
my $routerIP = '192.168.1.x';


# APPLICATION

my $useragent = LWP::UserAgent->new;
my $succes = 0;

# check if internet connection
while (!testIpOnline($routerIP)) {
	sleep(30);
}

# request lights status
my $turnoffRequest = HTTP::Request->new('GET', 'http://'.$hueBridgeIP.'/api/'.$hueKey.'/lights');
my $turnoffResult = $useragent->request($turnoffRequest);
my $resultLightStatus = decode_json( $turnoffResult->decoded_content );

# check if a light is still on
print "Checking if lights are still on...\n";
my $lightsActive = 0;

for (my $i = 1; $i < 3; $i++) {
	if ( $resultLightStatus->{$i}{"state"}{"on"} ) {
		print "Light " . $i . " is on\n";
		$lightsActive = 1;
	}
}

# if lights are on

if ( $lightsActive) {
	print "Checking if devices are present...\n";

	# ping desktop & cellphone multiple times

	my $allDevicesOffline = testAllDevicesOff();
	my $i = 0;

	while ( $allDevicesOffline && $i<3 ) {
		print "No devices are present";
		if ( $i < 2) {
			print ", retrying in 30 seconds...";
		}
		print "\n";
		sleep(30);
		$allDevicesOffline = testAllDevicesOff();
		$i++;
	}

	if ( $allDevicesOffline ) {

		# turn off all lights

		my $turnoffRequest = HTTP::Request->new('PUT', 'http://'.$hueBridgeIP.'/api/'.$hueKey.'/groups/0/action');
		$turnoffRequest->content_type('application/json');
		$turnoffRequest->content('{"on": false}');
		$useragent->request($turnoffRequest);

		print "Lights turned off!\n";
		$succes = 1;

	}


} else {
	print "No lights are on!\n";
}


# confirmation

if ($succes < 1) {
	print "Lights were not touched!\n";
}



# ping desktop & cellphone
sub testAllDevicesOff {

	my $count = 0;

	foreach my $ip (@deviceIPs){
		if (testIpOnline($ip) > 0) {
			return 0;
		}
	}

	return 1;


}

# ping ip
sub testIpOnline {

	my $ip = $_[0];

	print "Checking if ". $ip ." is online...\n";
	my $output = `ping $ip -c 3`;
	if ( index($output, ' 0% packet loss' ) > -1) {
		print $ip." online!\n";
		return 1;
	}
	print $ip ." is not online!\n";

	return 0;

}
