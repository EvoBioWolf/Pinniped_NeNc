#Creating 2bit from fasta
faToTwoBit GCF_000321225.1_Oros_1.0_genomic.fa GCF_000321225.1_Oros_1.0_genomic.2bit
#getting oligo sites for genome file GCF_000321225.1_Oros_1.0_genomic
oligoMatch oligo.fa GCF_000321225.1_Oros_1.0_genomic.2bit GCF_000321225.1_Oros_1.0_genomic.resbed
#Get individual enzyme cut bed
grep "	SbFI\+" GCF_000321225.1_Oros_1.0_genomic.resbed > SbFI.bed
#Get individual enzyme cut bed
grep "	MseI\+" GCF_000321225.1_Oros_1.0_genomic.resbed > MseI.bed
#get clusters using bedtools 
bedtools window -a SbFI.bed -b MseI.bed -w 500 > SbFI__MseI.join
#joining clusters
perl cluster.pl SbFI__MseI.join > GCF_000321225.1_Oros_1.0_genomic_SbFI__MseI.clusters
rm GCF_000321225.1_Oros_1.0_genomic.resbed GCF_000321225.1_Oros_1.0_genomic.2bit
