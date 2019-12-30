#name of the fasta file
#the fasta file should have .fa extension
#give the name without extension
#for example if the input fasta is Test.fa the NAME variable should be Test
# In this case the Fasta file name was Odo_ros.fa
NAME  := Odo_ros

#This will only work for restriction enzymes (SbFI and MseI). The ${NICKPOS} variable is not used
#enzyme details of rare cutter here (SbFI)
ENZYME_1    := SbFI
CUT_1       := CCTGCAGG
NICKPOS_1   := 2


#Enzyme details of common cutter
ENZYME_2    := MseI
CUT_2       := TTAA
NICKPOS_2   := 1

#seek distance for clusters
#The distance to look from a rare cutter site until a common cutter site is found
WINLEN      := 500

include ./Pipeline.mk
