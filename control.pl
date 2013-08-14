use Time::HiRes qw(usleep);
use Net::OpenSoundControl::Server;
use Net::OpenSoundControl::Client;

$client = Net::OpenSoundControl::Client->new(
      Host => "127.0.0.1", Port => 9999)
      or die "Could not start client: $@\n";
#$client->send(['/hello', 'i', $port]);

sub sendOSC {
	my @msg = @_;
	if($client) {
		$client->send(@msg);
	}
}

my @lines = ();
my @log = ();

#todo include OSC send macro

while(<STDIN>) {
	chomp;
	my $line = $_;
	if($line eq ".") {
		print "eval.\n";
		my $code = join("\n", @lines);
		push(@log, @lines);
		@lines = ();
		eval($code);
	}
	elsif($line =~ m/^osc/) {
		my @tmp = split(/ /, $line); #$tmp[0] is osc, [1] path, rest args (numbers)
		my @list = ($tmp[1]);
		my $f;
		shift @tmp; shift @tmp;
	     #todo
		foreach $f (@tmp) {
			push(@list, 'f');
			push(@list, $f);
		}
		&sendOSC([@list]);
	}
	elsif($line eq "quit") {
		open(LOG, ">>log.txt");
		print LOG join("\n", @log);
		close LOG;
	}
	else {
		push(@lines, $line);
	}
}






