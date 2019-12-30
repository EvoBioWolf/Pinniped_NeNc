use strict;
use warnings;
use Data::Dumper;
my %sbfiLoc;
while(<>)
{
	chomp;
	my @linelist=split "\t";
	my $chrom=$linelist[0];
	my $name=$linelist[-1];
	if(($linelist[2] - $linelist[1]) < 50){next}
	my @enzyme=split /__/,$name;
	#sbfiLoc all sbfi locations
	my $k=$chrom."__".$enzyme[0];
	if(!exists($sbfiLoc{$k})){$sbfiLoc{$k}=[]}
	push @{$sbfiLoc{$k}},\@linelist;
}
while(my ($key,$value) = each %sbfiLoc)
{
	#####if cluster has only one entry leave it alone
	my @cluster=@{$value};
	#get SbFI sites as a hash and add 0 to all values of the bash
	my %tmp=map {[split /__/,$_->[-1]]->[0]=>0} @cluster;
	#check if there is only one
	if(scalar keys %tmp > 1){die "More than 1 SbFI site found in the cluster"}
	my $sbfi=[keys %tmp]->[0];
	#check if string of SbFI+ matches
	if (substr($sbfi,0,5) ne 'SbFI+'){die "enzyme name not correct"};
	#get the location of sbfi
	my $sbfilocation=substr($sbfi,5);

	####add orientation right or left to the sbfi
	my @left;
	my @right;
	foreach(@cluster)
	{
		my $cur=$_;
		while(1)
		{
			#if start is less than sbfilocation then it is to the left and sbfi is at the end (far right)
			if($cur->[1] < $sbfilocation)
			{
				my $orient="L";
				#a check that the coordinate ends in sbfilocation
				if ($cur->[2] != ($sbfilocation+5)){die "Overhang incorrect"}
				#push the orientation and length to $cur
				push @{$cur},"L";
				push @{$cur},($cur->[2]-$cur->[1]);
				push @left,$cur;
				last;
			}
			#if the interval begins at the start of sbfi location the orientation wrt sbfi location is right
			if($cur->[1] == ($sbfilocation+1))
			{
				my $orient="R";
				push @{$cur},"R";
				push @{$cur},($cur->[2]-$cur->[1]);
				push @right,$cur;
				last;
			}
			die "Unsual condition giving up";
		}

	}
	#get only shortest left and right entries
	#sort by length of the clusters for both left and right (length is the last fied)
	my @lsorted = sort { $a->[-1] <=> $b->[-1] } @left;
	my @rsorted = sort { $a->[-1] <=> $b->[-1] } @right;

	#how many nucleotides to clip from left and right
	my $mclip=3;
	my $sclip=6;

	#print the first entry (which is not the shortest) and clip with these rules
	#if the cluster is has orientation left
		# - begins in msei clip 3 nucleotides from the start of bed interval (i.e increase the interval by 3 nucleotides)
		# - the cluster ends in sbfi clip 6 nucleotides from the end of interval (i.e decrease the interval by 6 nucleotides)
	# if the cluster has orientation right 	
		# - begins in sbfi so clip 6 nucl from the start (i.e increase the interval by 6 nucl)
		# - ends in msei so clip 3 nucl from the end (i.e descrease the interval by 3 nucleotides)
	# sometimes the clusters are only one sided so the array is empty. Don't print it in that case
	# also list the original start and end in name field with the added orientation with __ as delims
	print join("\t",($lsorted[0]->[0],($lsorted[0]->[1]+3),($lsorted[0]->[2]-6),$lsorted[0]->[3]."__".$lsorted[0]->[-2])),"\n" if scalar @lsorted > 0;
	print join("\t",($rsorted[0]->[0],($rsorted[0]->[1]+6),($rsorted[0]->[2]-3),$rsorted[0]->[3]."__".$rsorted[0]->[-2])),"\n" if scalar @rsorted > 0;
}
