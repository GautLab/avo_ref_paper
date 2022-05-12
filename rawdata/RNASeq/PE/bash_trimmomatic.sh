#!/bin/bash

PATH=/networkshare/bin/Trimmomatic-0.38:$PATH
TRIMMOMATIC="/networkshare/bin/Trimmomatic-0.38/"
TRIM="java -jar ${TRIMMOMATIC}trimmomatic-0.38.jar"
OPTIONS1="PE -threads 8 -phred33 -trimlog ./${OUTFILE}.log"
OPTIONS2="ILLUMINACLIP:${TRIMMOMATIC}adapters/TruSeq3-PE-2.fa:2:20:10 LEADING:0 TRAILING:0 SLIDINGWINDOW:4:15 MINLEN:5 AVGQUAL:20"

for i in $(ls SRR*.fastq | cut -d"_" -f1 | sort | uniq)
do
   INPUT="./${i}_1.fastq ./${i}_2.fastq"
   OUTPUT="./${i}_1_paired_trimm.fastq ./${i}_1_unpaired_trimm.fastq ./${i}_2_paired_trimm.fastq ./${i}_2_unpaired_trimm.fastq"
   ${TRIM} ${OPTIONS1} ${INPUT} ${OUTPUT} ${OPTIONS2}
done
