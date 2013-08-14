use Time::HiRes qw(usleep);
use Net::OpenSoundControl::Server;
use Net::OpenSoundControl::Client;

#usage: interpret.pl $filename $OSC_listenPort

my $fname = shift @ARGV;
my $port = shift @ARGV;

my $seqPos = -1;

open(IN, $fname);

@lines = ();

while(<IN>) {
	$line = $_;
	chomp($line);
	push(@lines, $line);
}
close(IN);

my $sTime = 250; # 250 ms
my $indx = 0;

my $synced = 0;

#&connectOSC(9999);

my $client;

$client = Net::OpenSoundControl::Client->new(
      Host => "127.0.0.1", Port => 9999)
      or die "Could not start client: $@\n";
$client->send(['/hello', 'i', $port]);

print "Waiting for connection response\n";

my $once = 1;

$server = Net::OpenSoundControl::Server->new(
  Port => $port, Handler => \&handler) or
  die "Could not start server: $@\n";
  
  $server->readloop();

#handles osc messages:
sub handler {
    my ($sender, $message) = @_;
	
	if($$message[0] eq '/sync/start') { $seqPos = 0; $synced = 1; }
	else { $seqPos++; }
	
	if(!$synced) { return; }

	if($once) { $once = 0; &intro; }

	print "Tick $seqPos.\n";
	
	$indx = $seqPos;
	 
    	#print $lines[$indx] . "\n";
	eval($lines[$indx]);
	#usleep($sTime * 1000 * $timeMult);
	$indx++;
	if($indx == scalar(@lines)) { $indx = 0; }
}

sub sendOSC {
	#print "Sending OSC";
	my @msg = @_;
	if($client) {
		$client->send(@msg);
	}
}
sub connectOSC {
	#print "Connecting OSC";
	my $port = shift;
	if($client) { return; } #already connected
	$client = Net::OpenSoundControl::Client->new(
      Host => "127.0.0.1", Port => $port)
      or die "Could not start client: $@\n";
}

sub intro {
	&connectOSC(9999);
	sendOSC(['/vol/stutter', 'f', 0.4]);
	for(my $i = 0; $i < 20; $i++) { # do this for 10 s
		usleep(1000 * 500);
		sendOSC(['/stutter/width', 'f', 0.05 * $i]);
	}
	

}
