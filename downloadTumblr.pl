#!/usr/bin/perl

# This script will download all photos from a Tumblr blog with the original quality
# all photos will be saved like <blogname>/<timestamp>_<tags>_<i>_<photosetsize>.<extension>

# You can edit the filename at line 77 (& 100)
# Check line 128 if you want to download blogs with a custom domain

# Register the script here: https://www.tumblr.com/oauth/register
# login here: https://api.tumblr.com/console/calls/user/info and allow application
# copy all four keys and run script!

my %oauth_api_params = (
	'consumer_key' =>
		'...',
	 'consumer_secret' =>
		'...',
	 'token' =>
		'...',
	 'token_secret' =>
		'...',
);

my $batchSize = 20;
my $keepGoingOnceAlreadyDownloadedFound = 0; # 0 or 1

# IMPORTS

use utf8;
use Fcntl qw(LOCK_EX LOCK_NB);
use File::NFSLock;
use LWP::UserAgent;
use HTTP::Request;
use JSON qw( decode_json );
use Image::Grab;
use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;

use strict;
use warnings;

my $lock = File::NFSLock->new($0, LOCK_EX|LOCK_NB);
die '$0 is already running!\n' unless $lock;
my $useragent = LWP::UserAgent->new;

# APPLICATION

# get blogname
my $blog = "";
if ($#ARGV != 0) {
	print "Which blog would you like to download? (NAME.tumblr.com): ";
	$blog = <STDIN>;
	chomp $blog;
	exit 0 if ($blog eq "");
} else { $blog = $ARGV[0] }

# start loop
my $i = 0;
my $count = 0;

while (1) {

	print "\nGetting the next ". $batchSize ." photo posts starting from post ". $i ."\n\n";

	# get posts
	my $response = getPage();
	my $posts = $response->{'posts'};

	# end when all pages are done
	if (!@$posts) {
		print "Done! Downloaded $count photos.\n";
		exit;
	}

	# loop over posts
	foreach my $post (@$posts) {

		# make filename
		my $tags = $post->{'tags'};
		my $filename = $post->{'timestamp'} . (@$tags ? "_". join("_", @$tags ) : "" );

		my $photos = $post->{'photos'};
		my $j = 0;
		foreach my $photo (@$photos) {
			$j++;

			my $align = "";
			if ($post->{'photoset_layout'}) {
				my $tmpcount = $j;
				foreach my $number ( split('', $align = $post->{'photoset_layout'}) ) {
					$tmpcount = $tmpcount-$number;
					if ($tmpcount <= 0) {
						$align = $number > 1 ? ( $number > 2 ? ( $number > 3 ? "": "\_triple" ) : "\_double" ) : "\_single";
						last;
					}
				}
			}

			# get url and extension
			my $url = $photo->{'original_size'}{'url'};
			my ($ext) = $url =~ /(\.[^.]+)$/;
			my $file = "$blog/$filename\_$j$align$ext";

			# make folder if it doesn't exist
			if ( !-d $blog ) {
				mkdir $blog;
			}

			# check if file already downloaded
			if (-e $file) {
				print "$file Already exists!\n";
				if ($keepGoingOnceAlreadyDownloadedFound) {
					print "Stopping script\n";
					exit;
				}
				next;
			}

			# save image
			saveImage($url,$file);

			$count = $count + 1;
		}

		print "\n";
	}

	$i = $i + $batchSize;
}

# request page
sub getPage {

	my $url = 'http://api.tumblr.com/v2/blog/'. $blog .'.tumblr.com/posts/photo?api_key='.$oauth_api_params{"consumer_key"}.'&offset='.$i.'&limit='.$batchSize;

	# make oauth request
	my $request = Net::OAuth->request('protected resource')->new(
		request_url => $url,
		%oauth_api_params,
		request_method => 'GET',
		signature_method => 'HMAC-SHA1',
		timestamp => time(),
		nonce => rand(1000000)
	);
	$request->sign;

	my $response = $useragent->get($url, Content => $request->to_post_body);

	#
	if ( $response->is_success ) {
		my $r = decode_json($response->content);
		if ($r->{'meta'}{'status'} == 200) {
			return $r->{'response'};
		} else { printf("Error: %s\n", $response->status_line); }
	} elsif ($response->code == 401) { die "Error: Unauthorized! (correct oauth keys?)\n";
	} elsif ($response->code == 404) { die "Error: Blog does not exist!\n";
	} else { printf("Error: %s\n", $response->status_line); }

}

sub saveImage {

	my $url = $_[0];
	my $file = $_[1];

	print "Saving $file\n";

	# saving image
	my $pic = new Image::Grab;
	$pic->url($url);
	$pic->grab;
	open(IMAGE, ">$file") || die "$file: $!";
	binmode IMAGE;  # for MSDOS derivations.
	print IMAGE $pic->image;
	close IMAGE;
}
