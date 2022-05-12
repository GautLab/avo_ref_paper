#!/bin/bash

source /gpool/.mybashrc
XSOMES=12
ASMSIZE=900000000

for i in $(ls *scaffolds.fasta)
do
    bioawk -cfastx '{print $name"\t"length($seq)}' $i | sort -rnk 2,2 > $(basename $i .fasta).lengths
    echo $i
    printf %.4f "$(( 10**4 * $(head -n ${XSOMES} $(basename $i .fasta).lengths | awk '{sum+=$2;} END {print sum;}')/${ASMSIZE} ))e-4"
    printf "\n"
    #printf %.4f "$(( 10**4 * $(awk '$2>=10000000 {sum+=$2;} END {print sum;}' $(basename $i .fasta).lengths)/${ASMSIZE} ))e-4"
    printf " \n"
    printf " \n"
done
