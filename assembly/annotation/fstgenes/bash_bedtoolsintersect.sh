#!/bin/bash

PATH=/gpool/bin/bedtools2/bin:$PATH

gtffile=$1
fstbedfile=$2
POSTFIX=$3

bedtools intersect -a ${fstbedfile} -b ${gtffile} > $(basename ${fstbedfile} .bed).${POSTFIX}geneovl
bedtools intersect -wa -a ${gtffile} -b ${fstbedfile} > $(basename ${fstbedfile} .bed).${POSTFIX}genes.gtf
