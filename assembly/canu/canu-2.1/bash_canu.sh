#!/bin/bash

PATH=/networkshare/bin/canu-2.0/Linux-amd64/bin:$PATH
LD_LIBRARY_PATH=/networkshare/bin/canu-2.0/Linux-amd64/lib:$PATH

PATH=/networkshare/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/networkshare/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/networkshare/bin/jre1.8.0_221/
export JRE_HOME=/networkshare/bin/jre1.8.0_221/

#TRIO1=Pinkerton.fa
#TRIO2=Thille.fa
PACBIO=gwen_pacb_subreads.fastq.gz
#NAME=$(basename ${TRIO1} .fa)

canu -p asm -d gwen genomeSize=900m -pacbio "${PACBIO}" useGrid=true
