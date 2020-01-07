use strict;
use warnings;
use Data::Dumper;
###############
# There are still some overlaps due to two sbFI sites being too close for comfort
# this will 
	# - get input from bedtools cluster
	# - when cluster has more than one member then 
		# - sort the cluster intervals by sbfi location
		# - get the leftmost interval from leftmost sbfi site
		# - get the rightmost interval from right most sbfi site
		# - rest all is ignored
##################

my %store;
while(<>)
{
	chomp;
	my @linelist=split "\t";
	my $clsno=$linelist[-1];
	if(!exists($store{$clsno})){$store{$clsno}=[] }
	push @{$store{$clsno}},\@linelist;
	
}
while(my ($key,$value)=each %store)
{
	my @cluster=@{$value};
	if(scalar @cluster > 1)
	{
		my @newcluster;

		foreach(@cluster)
		{
			my $sbfistring=[split /__/,$_->[3]]->[0];
			#check if string of SbFI+ matches
			if (substr($sbfistring,0,5) ne 'SbFI+'){die "enzyme name not correct for $sbfistring"};
			my $sbfiloc=substr($sbfistring,5);
			push @newcluster,[@{$_},$sbfiloc];
		}
		#sort by location of sbi sites 
		my @sorted= sort {$a->[-1] <=> $b->[-1]} @newcluster; 
		#choose extreme left and extreme right
		my $left=$sorted[0];
		my $right=$sorted[-1];
		if([split /__/,$left->[3]]->[-1] eq "L"){print join("\t",@{$left}[0..3]),"\n";}
		if([split /__/,$right->[3]]->[-1] eq "R"){print join("\t",@{$right}[0..3]),"\n";}

	}else{print join("\t",@{$cluster[0]}[0..3]),"\n"}

}
