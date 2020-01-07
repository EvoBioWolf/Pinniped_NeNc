#Creating 2bit from fasta
faToTwoBit Odo_ros.fa Odo_ros.2bit
#getting oligo sites for genome file Odo_ros
oligoMatch oligo.fa Odo_ros.2bit Odo_ros.resbed
#Get individual enzyme cut bed
grep "	SbFI\+" Odo_ros.resbed > SbFI.bed
#Get individual enzyme cut bed
grep "	MseI\+" Odo_ros.resbed > MseI.bed
#get clusters using bedtools 
bedtools window -a SbFI.bed -b MseI.bed -w 500 > SbFI__MseI.join
#joining clusters
perl cluster.pl SbFI__MseI.join > Odo_ros_SbFI__MseI.clusters
rm Odo_ros.resbed Odo_ros.2bit
