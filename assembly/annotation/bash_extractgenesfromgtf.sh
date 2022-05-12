#!/bin/bash

GTF=newgwen_braker_rnaseq_scaffold_annotation.gtf
awk '$3=="gene" {print}' ${GTF} | sort -k1,1V -k4,4n > $(basename ${GTF} .gtf).sorted.gtf
