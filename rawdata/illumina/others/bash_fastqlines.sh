#!/bin/bash
for i in $(ls *.gz)
do
   echo $(($(zcat $i | wc -l | awk '{print $1}')/4)) >> fastqlines.txt
done
