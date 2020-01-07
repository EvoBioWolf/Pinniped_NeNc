use strict;
use warnings;
use List::Util qw/max min/;
my $in=shift @ARGV;
open IN,"${in}" or die 'No in';
while(<IN>)
{
	chomp;
	my @linelist=split "\t";
	my @coor=(@linelist[1..2,7..8]);

	if($coor[0] < $coor[2])
	{
		if($coor[1] > $coor[3]){print $_;die "Wrong coordinates in bed ..."}
		print $linelist[0],"\t",$coor[0]+2,"\t",$coor[3]-1,"\t",$linelist[3],"__",$linelist[9],"\n";
	}else
	{
		print $linelist[0],"\t",$coor[2]+1,"\t",$coor[1]-2,"\t",$linelist[3],"__",$linelist[9],"\n";
	}

}

