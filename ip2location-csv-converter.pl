#!/usr/bin/perl
use strict;
use Socket;
use Net::CIDR;

my $conversionMode = 'range';
my $writeMode = 'replace';

my $inputfile = '';
my $outputfile = '';
my $param1 = '';
my $param2  = '';

if (($#ARGV + 1) < 2)
{
	die('ERORR: Missing parameters.'); # at the minimum, should have 2 params. the input & output files.
}

if (($#ARGV + 1) == 2)
{
	$inputfile = $ARGV[0];
	$outputfile = $ARGV[1];
}
elsif (($#ARGV + 1) == 3)
{
	$param1 = $ARGV[0];
	$inputfile = $ARGV[1];
	$outputfile = $ARGV[2];
}
elsif (($#ARGV + 1) == 4)
{
	$param1 = $ARGV[0];
	$param2 = $ARGV[1];
	$inputfile = $ARGV[2];
	$outputfile = $ARGV[3];
}

if ($param1 =~ /^\-(range|cidr)$/)
{
	$conversionMode = $1;
}
elsif ($param1 =~ /^\-(replace|append)$/)
{
	$writeMode = $1;
}

if ($param2 =~ /^\-(range|cidr)$/)
{
	$conversionMode = $1;
}
elsif ($param2 =~ /^\-(replace|append)$/)
{
	$writeMode = $1;
}

sub long2ip
{
	return inet_ntoa(pack("N*", shift));
}

open my $in, "<", $inputfile or die "ERROR: Cannot open input file.";
open my $out, ">", $outputfile or die "ERROR: Cannot write to output file.";
binmode $in;
binmode $out;

while (<$in>)
{
	my $line = $_;
	
	if ($line =~ /^"(\d+)","(\d+)"(.*)/)
	{
		my $tmp = '';
		if ($conversionMode eq 'range')
		{
			if ($writeMode eq 'append')
			{
				$tmp = '"' . $1 . '","' . $2 . '",';
			}
			print $out $tmp . '"' . &long2ip($1) . '","' . &long2ip($2) . '"' . $3;
		}
		elsif ($conversionMode eq 'cidr')
		{
			if ($writeMode eq 'append')
			{
				$tmp = '"' . $1 . '","' . $2 . '",';
			}
			my @cidr = Net::CIDR::range2cidr(&long2ip($1) . '-' . &long2ip($2));
			foreach (@cidr)
			{
				print $out $tmp . '"' . $_ . '"' . $3;
			}
		}
	}
}

close $in;
close $out;
