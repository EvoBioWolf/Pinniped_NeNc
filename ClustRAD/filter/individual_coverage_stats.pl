use strict;
use warnings;
use List::Util qw/max/;

#########################
#in case of issues   
#saurabhdilip@gmail.com
#########################
#The scripts filters out individuals based on the coverage

my $bamlistfile  = shift @ARGV;
my $coveragefile = shift @ARGV;
my $percentage   = shift @ARGV;
#read in bamnames
my @bamnames;
open BMLFILE,"$bamlistfile" or die "no $bamlistfile";
while(<BMLFILE>){ chomp; push(@bamnames,$_) }
die;

open IN,"$coveragefile" or die "no in";
my @stats=(0)x23;
while(<IN>)
{
	chomp;
	my @linelist=split "\t";
	my @cur=@linelist[4..$#linelist];
	my $i=0;
	foreach(@cur)
	{
		if($_ > 2 ){$stats[$i]++}
		$i++
	}
}
my $max=max @stats;
foreach(@stats)
{
	my $perc=(($_*100)/$max);
	my $x=$perc>20?"PASS":"FAIL";
	print $_,"\t",sprintf("%.2f",$perc),"\t",$x,"\n";
}

