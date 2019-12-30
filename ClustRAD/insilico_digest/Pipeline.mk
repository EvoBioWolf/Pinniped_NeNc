.DELETE_ON_ERROR:

define printOligo
>${ENZYME_1}
${CUT_1}
>${ENZYME_2}
${CUT_2}
endef

New: \
	oligo.fa \
	${ENZYME_1}.bed \
	${ENZYME_2}.bed \
	${ENZYME_1}__${ENZYME_2}.join \
	${NAME}_${ENZYME_1}__${ENZYME_2}.clusters
oligo.fa:
	#printing enzyme cut sequence to $@
	$(file > $@,${printOligo})

%.resbed: oligo.fa %.2bit
	#getting oligo sites for genome file ${*}
	oligoMatch $< $(word 2,$^) $@

%.bed:${NAME}.resbed
	#Get individual enzyme cut bed
	grep "	${*}\+" $< > $@

${ENZYME_1}__${ENZYME_2}.join:${ENZYME_1:=.bed} ${ENZYME_2:=.bed}
	#get clusters using bedtools 
	bedtools window -a $< -b $(word 2,$^) -w ${WINLEN} > $@

${NAME}_%.clusters:cluster.pl %.join
	#joining clusters
	perl $^ > $@
%.2bit:%.fa
	#Creating 2bit from fasta
	faToTwoBit $< $@
clean:
	rm -f oligo.fa \
	${ENZYME_1}.bed \
	${ENZYME_2}.bed \
	${ENZYME_1}__${ENZYME_2}.join \
	${NAME}_${ENZYME_1}__${ENZYME_2}.clusters
