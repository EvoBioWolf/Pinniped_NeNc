use strict;
use warnings;
use List::Util qw/max/;
#########################
#in case of issues   
#saurabhdilip@gmail.com
#########################
#The scripts filters out individuals based on the coverage

my $covfile     = shift @ARGV;
my $cutoff      = shift @ARGV;
my $logfile     = shift @ARGV;
#open coverage file
open IN,"${covfile}" or die "no in";
#get header from coverage file
chomp(my $header=<IN>);
my @header=split "\t",$header;

#get sample list 
my @bamlist=@header[4 .. $#header];
#initialize arrays for each sample name
my @stats= (0) x scalar(@bamlist);
my @store;
my %total;
foreach(@bamlist){$total{$_}=0}

#read in coverage file
while(<IN>)
{
	chomp;
	my @linelist=split "\t";
	if(scalar @header != scalar @linelist){die "Parsing Error..."}

	my %linedict;
	@linedict{@header}=@linelist;
	push @store,\%linedict;
	#get coverage values for samples
	my @cur=@linedict{@bamlist};
	my $i=0;
	#atleast 3 reads
	foreach(keys %total){if($linedict{$_} > 2){$total{$_}+=1} }

	foreach(@cur) { if($_ > 2 ){$stats[$i]++};$i++ }
}

my $max= max values(%total);

my @passed=("CHROM","START","STOP","NAME");
open LOG,">${logfile}" or die 'No logfile open..';
foreach(@bamlist)
{
	
	my $cur=$total{$_};
	my $perc=(($cur*100)/$max);
	my $x=$perc>=$cutoff?"PASS":"FAIL";
	if($x eq 'PASS'){push @passed,$_}
	print LOG $_,"\t",$cur,"\t",sprintf("%.2f",$perc),"\t",$x,"\n";
}
print join("\t",@passed),"\n";
foreach(@store)
{
	my @printlist;
	my %curdict=%{$_};
	foreach(@passed)
	{
		push @printlist,$curdict{$_};
	} 
	print join("\t",@printlist),"\n";
}
