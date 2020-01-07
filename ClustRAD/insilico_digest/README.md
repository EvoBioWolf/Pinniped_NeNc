
### Abstract

This pipeline finds intervals between a rare cutter (SbFI) and a common cutter (MseI) in a given fasta file.
Steps

* Find SbFI and MseI cut sites in  the genome using oligomatch tool from UCSC toolkit
* From each SbFI site look for a given distance if a MseI site is present using bedtools
* Generate a bedfile of clusters of enzyme cut sites (one SbFI with one or more MseI sites)

### Dependencies
* bedtools
* Following Kent utilities from UCSC genome browser (Can be downloaded here `http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/`)
	- faToTwoBit
	- oligoMatch

### To Run
* Keep the genome fasta file in this folder. The file should have a .fa extension
* Edit the `Settings.mk` file with the genome name
* For example if the name of genome is odoRosDiv0, the fasta file should be `odoRosDiv0.fa`
* Change the variable NAME in Makefile to genome name i.e fasta file name without the fa extension. For this example `NAME := odoRosDiv0`
* make sure to run make clean before running the pipeline
* type make on terminal to run the pipeline
* The final result file name would be `${NAME}_${ENZYME_1}__${ENZYME_2}.clusters`. For the example the name would be `odoRosDiv0_SbFI__MseI.clusters`

### Limitations
Right now the pipeline only works for SbFI and MseI but can be adapted for other enzyme combinations.
