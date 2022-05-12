#!/bin/bash

PATH=/gpool/bin/gt-1.6.2-Linux_x86_64-64bit-complete/bin:$PATH

GTFFILE=gwen_braker_rnaseq_correct_scaffold_annotation.gtf

gt gtf_to_gff3 <(grep -P "\tCDS\t|\texon\t" ${GTFFILE} ) > $(basename ${GTFFILE} .gtf).gff3
