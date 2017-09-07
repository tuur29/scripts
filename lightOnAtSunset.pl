#!/usr/bin/perl

# This Perl script will check if the sun has set within the hour, if a certain device is turned on (pingable) and if all lights are off
# If this is so, the configured Phillips Hue scene will be activated (Hue bridge is needed)

# You can disable this behavior by make a file 'disableHue' in the same directory
# By uncommenting the block below you can make it check in with a light sensor

use strict;
use warnings;

use Fcntl qw(LOCK_EX LOCK_NB);
use File::NFSLock;

my $lock = File::NFSLock->new($0, LOCK_EX|LOCK_NB);
die "$0 is already running!\n" unless $lock;

die "Hue automation disabled" if -e "disableHue";

# check if dark outside
# my $darkOutside = qx(python /home/pi/checkLux.py);
# if ( !($darkOutside+0) ) {
# 	die "It's still bright!\n";
# }


use LWP::UserAgent;
use HTTP::Request;
use Net::Ping;
use JSON qw( decode_json );
use DateTime;
use DateTime::Format::ISO8601;

# CONFIG
# https://www.developers.meethue.com/documentation/getting-started
my $hueKey = '...';
my $hueBridgeIP = '192.168.1.x';
my $hueScene = '...';
my $deviceIP = '192.168.1.x';
my $routerIP = '192.168.1.x';
# http://sunrise-sunset.org/api
my $latitude = '...';
my $longitude = '...';


# APPLICATION

# check if internet connection
while (!testIpOnline($routerIP)) {
	print "No internet connection, retrying in 30 seconds\n";
	sleep(30);
}

print "Checking if light is already on...\n";


# request lights status
my $succes = 0;
my $useragent = LWP::UserAgent->new;
my $turnoffRequest = HTTP::Request->new('GET', 'http://'.$hueBridgeIP.'/api/'.$hueKey.'/lights');
my $turnoffResult = $useragent->request($turnoffRequest);
my $resultLightStatus = decode_json( $turnoffResult->decoded_content );


# check if a light is already on

my $lightActive = 0;

for (my $i = 1; $i < 3; $i++) {
	if ( $resultLightStatus->{$i}{"state"}{"on"} ) {
		print "Light " . $i . " is on\n";
		$lightActive = 1;
	}
}


# if lights are not on

if ( !$lightActive ) {

	print "No lights are on.\n";

	# ping device

	if ( testIpOnline($deviceIP) ) {

		# get sunset

		print "Getting sunset timestamp...\n";

		my $now = DateTime->now;

		my $sunsetRequest = HTTP::Request->new('GET', 'http://api.sunrise-sunset.org/json?lat='.$latitude.'&lng='.$longitude.'&formatted=0');
		my $sunsetResult = $useragent->request($sunsetRequest);
		my $resultData = decode_json( $sunsetResult->decoded_content );
		
		my $key = "sunset";
		if ( $now->month < 10 && $now->month > 5 ) {
			$key = "civil_twilight_end";
		}

		my $parser = DateTime::Format::ISO8601->new;
		my $sunset = $parser->parse_datetime( $resultData->{"results"}{$key} );
			
		print "It is: " . $now->ymd . " " . $now->hms."\n";
		print "Sunset at: " . $sunset->ymd . " " . $sunset->hms."\n";

		if ( DateTime->compare($now, $sunset) > 0 ) {

			if ( DateTime->compare($now, $sunset->add(hours => 1)) < 0 ) {

				print "Sun has set within the hour.\n";

				# turn on bureau light

				my $turnoffRequest = HTTP::Request->new('PUT', 'http://'.$hueBridgeIP.'/api/'.$hueKey.'/groups/0/action');
				$turnoffRequest->content_type('application/json');
				$turnoffRequest->content('{"scene": "'.$hueScene.'"}');

				$useragent->request($turnoffRequest);

				print "Light 1 turned on!\n";
				$succes = 1;

			} else {

				print "Sun has set too long ago!\n";
			}

		} else {

			print "It is still light outside!\n";
		}

	}


} else {
	print "Some lights are already on!\n";
}


# confirmation

if ($succes < 1) {
	print "Light was not touched!\n";
}


# ping ip
sub testIpOnline {

	my $ip = $_[0];

	# print "Checking if ". $ip ." is online...\n";
	# my $output = `ping $ip -c 3`;
	# if ( index($output, ' 0% packet loss' ) > -1) {
	# 	print $ip." online!\n";
	# 	return 1;
	# }
	# print $ip ." is not online!\n";

	# return 0;

	print "Checking if ". $ip ." is online...\n";
	open(my $file,  "<",  "/home/pi/devices.txt")  or die "Can't open devices.txt:";

	while (<$file>)  {
		if (/$ip/) {
			print $ip." online!\n";
			return 1;
		}
	}

	print $ip ." is not online!\n";
	return 0;

}
