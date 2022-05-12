#!/bin/bash

PATH=/gpool/bin/bedtools2/bin:$PATH

GTF=$1
CONTIGREF=pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta
SCAFFREF=gwen_scaffolds.fasta

bedtools getfasta -s -fi ${CONTIGREF} -bed ${GTF} > output1.gtf
bedtools getfasta -s -fi ${SCAFFREF} -bed new${GTF} > output2.gtf
