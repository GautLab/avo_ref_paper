#!/bin/bash

PATH=/gpool/bin/bedtools2/bin/bedtools/gpool/bin/bedtools2/bin:$PATH
REF=pamericana_hass_pnas.fasta

for i in $(ls pamericana*.gff)
do
   echo $i
   awk '{print $1"\t"$4"\t"$5"\t"$3"::"$1":"$4-1"-"$5"\t42\t"$7"\t"$5-$4+1"M"}' $i > $(basename $i .gff).bed
   bedtools getfasta -s -fi ${REF} -bed $(basename $i .gff).bed -fo $(basename $i .gff).fasta
done
