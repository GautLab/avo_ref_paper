#!/bin/bash

PATH=/networkshare/bin/Trimmomatic-0.38:$PATH
TRIMMOMATIC="/networkshare/bin/Trimmomatic-0.38/"
TRIM="java -jar ${TRIMMOMATIC}trimmomatic-0.38.jar"
OPTIONS1="SE -threads 8 -phred33 -trimlog ./${OUTFILE}.log"
OPTIONS2="ILLUMINACLIP:${TRIMMOMATIC}adapters/TruSeq3-SE-2.fa:2:20:10 LEADING:0 TRAILING:0 SLIDINGWINDOW:4:15 MINLEN:5 AVGQUAL:20"

for i in $(ls SRR*.fastq | cut -d"." -f1 | sort | uniq)
do
   INPUT="./${i}.fastq"
   OUTPUT="./${i}_unpaired_trimm.fastq"
   ${TRIM} ${OPTIONS1} ${INPUT} ${OUTPUT} ${OPTIONS2}
done
