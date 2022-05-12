#!/bin/bash
PATH=/gpool/bin/bedtools2/bin:$PATH

bedtools intersect -v -b gwen_TE_annotation.bed -a gwen_braker_rnaseq_annotation.gtf > gwen_braker_rnaseq_annotation_woTEs.gtf
bedtools intersect -v -b gwen_TE_annotation.bed -a gwen_braker_rnaseq_hapsolo_annotation.gtf > gwen_braker_rnaseq_hapsolo_annotation_woTEs.gtf
bedtools intersect -v -b gwen_TE_annotation.bed -a gwen_braker_rnaseq_scaffold_annotation.gtf > gwen_braker_rnaseq_scaffold_annotation_woTEs.gtf

awk '$3 == "gene" {print $3}' gwen_braker_rnaseq_annotation_woTEs.gtf | wc -l
