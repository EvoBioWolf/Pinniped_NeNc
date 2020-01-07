use strict;
use warnings;
#####################################
# this perl script pastes coverage files generated in ./coverage/ for each poplulation
#####################################
use List::Util qw /uniq/;
my $infile=shift @ARGV;
open IN,"${infile}" or die "no in";
chomp(my $header=<IN>);
my @header=split / /,$header;
print join("\t",('CHROM','START','STOP','NAME',@header)),"\n";
while(<IN>)
{
	chomp;
	my @linelist=split / /;
	if(scalar @linelist != scalar @header){die "Parsing Error..."}
	my @test=map {[split "\t"] } @linelist;
	my @totest= map {join("\t",($_->[0],$_->[1],$_->[2],$_->[3])) } @test;
	#just paranoid but good to check if bed files are propely aligned
	if (scalar(uniq @totest) != 1){die "Field mismatch;bed files are not aligned..."}
	my %linedict;
	@linedict{@header}=@test;
	my @toprint;
	push @toprint,$totest[0];
	foreach(@header){push @toprint,$linedict{$_}->[-1]}
	print join ("\t",@toprint),"\n";
}
