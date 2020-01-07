#########################
#in case of issues   
#########################

#Genome name 
NAME    := Odo_ros

#Location (folder) of bam files with relative path
BAMLOC  := ../mergeBams

#sample info file
INFO         := ${NAME}.sampleinfo

#name of file containing clusters
#strictly should be bed3 file
#this file is produced by ../insilico_digest/
CLUSTERS   := Odo_ros_SbFI__MseI.clusters
#Relative path to the folder where the bed3 file is 
CLUSTERLOC :=  ../insilico_digest

#Filters
FILTERS    := F0 F20 F50 F60 F70

#Filter params
#Number of reads
NR         := 3

#Coverage cutoff
COV        := -f 0.99

#min Individuals 
MINSAMPLES := 3

#Min aln quality
#depends on aligner
#for stampy I found 70 to be good
#stampy does not give an explicit alignment score
MINALNQ   := -q 70
