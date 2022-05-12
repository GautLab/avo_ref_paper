#!/bin/bash
PATH=/gpool/bin/bedtools2/bin:$PATH
TEANNOTATION=gwen_TE_annotation.bed
STEANNOTATION=gwen_TE_annotation.sense.bed
ASTEANNOTATION=gwen_TE_annotation.antisense.bed

#ANNOTATION=gwen_braker_rnaseq_hapsolo_annotation.gtf
#ANNOTATION=gwen_braker_rnaseq_scaffold_annotation.gtf
ANNOTATION=pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.gtf

#Genes
#awk -F "\t" '$3 == "gene" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' ${ANNOTATION} > $(basename ${ANNOTATION} .gtf).genes.gtf
#awk -F "\t" '$7 == "+" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' $(basename ${ANNOTATION} .gtf).genes.gtf > $(basename ${ANNOTATION} .gtf).genes.sense.gtf
#awk -F "\t" '$7 == "-" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' $(basename ${ANNOTATION} .gtf).genes.gtf > $(basename ${ANNOTATION} .gtf).genes.antisense.gtf

#Exons
#awk -F "\t" '$3 == "exon" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' ${ANNOTATION} > $(basename ${ANNOTATION} .gtf).exons.gtf
#awk -F "\t" '$7 == "+" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' $(basename ${ANNOTATION} .gtf).exons.gtf > $(basename ${ANNOTATION} .gtf).exons.sense.gtf
#awk -F "\t" '$7 == "-" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' $(basename ${ANNOTATION} .gtf).exons.gtf > $(basename ${ANNOTATION} .gtf).exons.antisense.gtf

#Transcripts
#awk -F "\t" '$3 == "transcript" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' ${ANNOTATION} > $(basename ${ANNOTATION} .gtf).transcripts.gtf
#awk -F "\t" '$7 == "+" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' $(basename ${ANNOTATION} .gtf).transcripts.gtf > $(basename ${ANNOTATION} .gtf).transcripts.sense.gtf
#awk -F "\t" '$7 == "-" {print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8"\t"$9}' $(basename ${ANNOTATION} .gtf).transcripts.gtf > $(basename ${ANNOTATION} .gtf).transcripts.antisense.gtf

#Sense
###awk '$4 == "-" {print $1"\t"$2"\t"$3"\t"$4}' ${TEANNOTATION} > ${STEANNOTATION}
#Genes
#bedtools intersect -v -b ${STEANNOTATION} -a $(basename ${ANNOTATION} .gtf).genes.sense.gtf > $(basename ${ANNOTATION} .gtf).genes.sense.woTEs.gtf
#Exons
#bedtools intersect -v -b ${STEANNOTATION} -a $(basename ${ANNOTATION} .gtf).exons.sense.gtf > $(basename ${ANNOTATION} .gtf).exons.sense.woTEs.gtf
#Transcripts
#bedtools intersect -v -b ${STEANNOTATION} -a $(basename ${ANNOTATION} .gtf).transcripts.sense.gtf > $(basename ${ANNOTATION} .gtf).transcripts.sense.woTEs.gtf
#Exons with TEs
bedtools intersect -b ${STEANNOTATION} -a $(basename ${ANNOTATION} .gtf).exons.sense.gtf > $(basename ${ANNOTATION} .gtf).exons.sense.wTEs.gtf
awk -F'\t' '{print $9}' $(basename ${ANNOTATION} .gtf).exons.sense.wTEs.gtf | awk '{print $4}' | cut -d"_" -f5 | cut -d'"' -f1 | grep jg | sort | uniq > $(basename ${ANNOTATION} .gtf).exons.sense.wTEs.genelist
#Exons w/o TEs
awk -F'\t' '{print $9}' $(basename ${ANNOTATION} .gtf).exons.sense.woTEs.gtf | awk '{print $4}' | cut -d"_" -f5 | cut -d'"' -f1 | grep jg | sort | uniq > $(basename ${ANNOTATION} .gtf).exons.sense.woTEs.genelist

#Antisense
###awk '$4 == "-" {print $1"\t"$2"\t"$3"\t"$4}' ${TEANNOTATION} > ${ASTEANNOTATION}
#Genes
#bedtools intersect -v -b ${ASTEANNOTATION} -a $(basename ${ANNOTATION} .gtf).genes.antisense.gtf > $(basename ${ANNOTATION} .gtf).genes.antisense.woTEs.gtf
#Exons
#bedtools intersect -v -b ${ASTEANNOTATION} -a $(basename ${ANNOTATION} .gtf).exons.antisense.gtf > $(basename ${ANNOTATION} .gtf).exons.antisense.woTEs.gtf
#Transcripts
#bedtools intersect -v -b ${ASTEANNOTATION} -a $(basename ${ANNOTATION} .gtf).transcripts.antisense.gtf > $(basename ${ANNOTATION} .gtf).transcripts.antisense.woTEs.gtf
#Exons with TEs
bedtools intersect -b ${ASTEANNOTATION} -a $(basename ${ANNOTATION} .gtf).exons.sense.gtf > $(basename ${ANNOTATION} .gtf).exons.antisense.wTEs.gtf
awk -F'\t' '{print $9}' $(basename ${ANNOTATION} .gtf).exons.antisense.wTEs.gtf | awk '{print $4}' | cut -d"_" -f5 | cut -d'"' -f1 | grep jg | sort | uniq > $(basename ${ANNOTATION} .gtf).exons.antisense.wTEs.genelist
#Exons w/o TEs
awk -F'\t' '{print $9}' $(basename ${ANNOTATION} .gtf).exons.antisense.woTEs.gtf | awk '{print $4}' | cut -d"_" -f5 | cut -d'"' -f1 | grep jg | sort | uniq > $(basename ${ANNOTATION} .gtf).exons.antisense.woTEs.genelist
