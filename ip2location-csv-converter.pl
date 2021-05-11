#!/usr/bin/perl
use strict;
use Socket;
use Net::CIDR;
use Math::BigInt;
use Math::BigInt lib => 'GMP';
use Net::IPv6Addr 'from_bigint';

my $ipv4max = Math::BigInt->new("4294967295");

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

if ($param1 =~ /^\-(range|cidr|hex)$/)
{
	$conversionMode = $1;
}
elsif ($param1 =~ /^\-(replace|append)$/)
{
	$writeMode = $1;
}

if ($param2 =~ /^\-(range|cidr|hex)$/)
{
	$conversionMode = $1;
}
elsif ($param2 =~ /^\-(replace|append)$/)
{
	$writeMode = $1;
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
			my ($x1, $x2) = &getipstring($1, $2);
			print $out $tmp . '"' . $x1 . '","' . $x2 . '"' . $3;
		}
		elsif ($conversionMode eq 'cidr')
		{
			if ($writeMode eq 'append')
			{
				$tmp = '"' . $1 . '","' . $2 . '",';
			}
			my @cidr = &getcidr($1, $2);
			foreach (@cidr)
			{
				print $out $tmp . '"' . $_ . '"' . $3;
			}
		}
		elsif ($conversionMode eq 'hex')
		{
			if ($writeMode eq 'append')
			{
				$tmp = '"' . $1 . '","' . $2 . '",';
			}
			my ($x1, $x2) = &gethex($1, $2);
			print $out $tmp . '"' . $x1 . '","' . $x2 . '"' . $3;
		}
	}
}

close $in;
close $out;

sub long2ip
{
	return inet_ntoa(pack("N*", shift));
}


sub getcidr
{
	my $dec = shift;
	my $dec2 = shift;
	my $x = Math::BigInt->new("$dec");
	my $x2 = Math::BigInt->new("$dec2");
	if ($x2->bgt($ipv4max))
	{
		return Net::CIDR::range2cidr(from_bigint($x)->to_string_compressed() . '-' . from_bigint($x2)->to_string_compressed());
	}
	else
	{
		return Net::CIDR::range2cidr(&long2ip($dec) . '-' . &long2ip($dec2));
	}
}

sub getipstring
{
	my $dec = shift;
	my $dec2 = shift;
	my $x = Math::BigInt->new("$dec");
	my $x2 = Math::BigInt->new("$dec2");
	if ($x2->bgt($ipv4max))
	{
		return (from_bigint($x)->to_string_compressed(), from_bigint($x2)->to_string_compressed());
	}
	else
	{
		return (&long2ip($dec), &long2ip($dec2));
	}
}

sub gethex
{
	my $dec = shift;
	my $dec2 = shift;
	my $x = Math::BigInt->new("$dec");
	my $x2 = Math::BigInt->new("$dec2");
	my $pad = 8; # ipv4
	if ($x2->bgt($ipv4max))
	{
		$pad = 32; # ipv6
	}
	my $xx = $x->as_hex();
	my $xx2 = $x2->as_hex();
	$xx =~ s/^0x//;
	$xx2 =~ s/^0x//;
	$xx = ('0' x ($pad - length($xx))) . $xx;
	$xx2 = ('0' x ($pad - length($xx2))) . $xx2;
	return ($xx, $xx2);
}
