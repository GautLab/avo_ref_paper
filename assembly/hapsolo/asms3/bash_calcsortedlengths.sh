#!/bin/bash

source /networkshare/.mybashrc
xsomes=12

for i in $(ls *primary.fasta)
do
    bioawk -cfastx '{print $name"\t"length($seq)}' $i | sort -rnk 2,2 > $(basename $i .fasta).lengths
    echo $i
    head -n ${xsomes} $(basename $i .fasta).lengths | awk '{sum+=$2;} END {print sum;}'
    awk '$2>=10000000 {sum+=$2;} END {print sum;}' $(basename $i .fasta).lengths
done
