#!/usr/bin/perl
# Fahhem's attempt at writing a perl script to customize the
#  LD BigROM. I haven't used perl for many years and I don't
#  even remember what I wrote with it.

# Loop through the non-comment lines in appMap
# Ask if they want the app
#   If no, continue;
#   If yes, add the lines to custom.conf

$customconf = 'custom.conf';
$appmap = 'appMap';

# create a lock file
$lockfile="custom.conf.loc";
if (-e $lockfile) {
	print "Please wait for other instances of this program to finish.\nIf there are no instances running, delete $lockfile.\n";
	die;
}
open (LOCK,">$lockfile") || die ("Cannot open lock file!\n");
close (LOCK);

open (CONF,">$customconf");
print CONF <<EOF;
# Comments start with #
#
# HowTo Modify this file:
#
# General info:
# Locale: l_LOCALE
# Program with ending wildcard: pFILENAMES
# Program with no wildcards: PFILENAME
# Program with beginning/middle wildcards: PBEGINNING*MIDDLE*ENDING
#
# Verbose info:
# To delete a locale, place:
# "l_enUS" for enUS and "l_ptBR" for brazilian portugese
# programs are "pNAME" so pAddIt removes files starting with AddIt
# for support with name with wildcards in different places, put a * 
#  in the name.
# To specify that tmobile filenames are tmobile*_app* you can put
#  ptmobile*_app (the last * is implied unless you put P at the beginning)
# 
EOF


open (FILE,$appmap);
@lines = <FILE>;
close(FILE);

foreach $line(@lines) {
	if ($line !~ /^#/ )
	{
		#print $line;
		$_=$line;
		/\|/;
		#print "$`\n$&\n$'\n";
		$start=$`;
		$line=$';
		print "Do you want to remove $start? ";
		while(chomp($yesno = <>))
		{
			if ( $yesno =~ /^y/i ) {
				$start=~ s/^(\S+) *.*$/\1/;
				print "$start will be removed.\n";
				while ($line =~ /(.+?)(\||\Z)/g) {
					print CONF "$1\n";
				}
				last;
			} elsif ( $yesno =~ /^n/i ) {
				print "$start will be kept.\n";
				last;
			}
		}
	}
}
close(CONF);
print "Finished.\n";
unlink($lockfile);
