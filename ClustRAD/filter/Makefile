SHELL := /bin/bash
#############################
# Output file name FILTER__POPULATION__SPECIES__REFERENCE.{cov,log,clusters,nocls}
##############################
include Settings.mk
.SECONDEXPANSION:
.DELETE_ON_ERROR:
VPATH        := ${BAMLOC} ${CLUSTERLOC}
CLUSTERNAME  := ${CLUSTERS:.clusters=}
ALL_BAMS     := $(shell \ls ${BAMLOC}|grep "\.bam$$")
## take bam inputs from a text file
POPS         := $(shell cat ${NAME:=.poplist} )
#varaibles for filenames
POPS_NAME     := $(addsuffix __${NAME},${POPS})
POPS_NAME_CLS := $(addsuffix __${CLUSTERS:.clusters=},${POPS_NAME})


$(foreach P,${POPS},$(eval ${P}=$(shell cat ${P:=.bamlist})))
$(foreach X,${POPS},$(eval ${X}_COV=$(addprefix coverage/,${${X}:.bam=__${CLUSTERNAME}.cov} )))

define Filter
${1}__%.cov ${1}__%.log:cluster_individual_stats_calc.pl %.cov
	#Filtering indviduals out with percentage cutoff ${1}%
	perl $$^ $(subst F,,${1}) $${@:.cov=.log} > ${1}__$${*}.cov
endef


All: \
	$(addprefix coverage/,${ALL_BAMS:.bam=__${CLUSTERS:.clusters=.cov}}) \
	${POPS_NAME_CLS:=.cov} \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.cov})) \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.log})) \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.clusters}))  \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.nocls}))


coverage/%__${CLUSTERS:.clusters=.cov}:%.bam ${CLUSTERS}
	#calculating coverage for bam $< with cluster bed file ${CLUSTERS}
	bedtools multicov -bams $< -bed $(word 2,$^) ${COV} ${MINALNQ}  > $@

%__${NAME}__${CLUSTERS:.clusters=.cov}:joiner.pl %.bamlist $${%_COV}
	#joining coverage files for population ${*}
	(echo ${${*}};paste -d " " ${${*}_COV})|perl $< - > $@

$(foreach F,${FILTERS},$(eval $(call Filter,${F})) )

%.clusters:%.cov
	#keep intervals with atleast  3 reads in 3 individuals filter
	perl -lane '{ @TMP= grep {$$_ > ${NR} } @F[4..$$#F];if(scalar(@TMP) >= ${MINSAMPLES} &&  $$F[0] ne "CHROM" ){print join("\t", @F[0..3])} }' $< > $@
%.nocls:%.clusters
	cat $< |sort -k1,1 -k2,2n | perl no_clusters.pl |sort -k1,1 -k2,2n |bedtools cluster -i - |sort -k1,1 -k2,2n |perl final_filter.pl |sort -k1,1 -k2,2n > $@
	
IntermediateClean:
	rm $(addprefix coverage/,${ALL_BAMS:.bam=__${CLUSTERS:.clusters=.cov}}) \
	${POPS_NAME_CLS:=.cov} \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.cov})) \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.log}))
AllClean:
	rm $(addprefix coverage/,${ALL_BAMS:.bam=__${CLUSTERS:.clusters=.cov}}) \
	${POPS_NAME_CLS:=.cov} \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.cov})) \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.log})) \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.clusters}))  \
	$(foreach F,${FILTERS},$(addprefix ${F}__,${POPS_NAME_CLS:=.nocls}))
