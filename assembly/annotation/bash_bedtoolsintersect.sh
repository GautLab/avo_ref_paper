#!/bin/bash

PATH=/gpool/bin/bedtools2/bin:$PATH

gtffile=$1
fstbedfile=$2
PREFIX=$3

bedtools intersect -a ${fstbedfile} -b ${gtffile} > $(basename ${fstbedfile} .bed).${PREFIX}geneovl
bedtools intersect -wa -a ${gtffile} -b ${fstbedfile} > $(basename ${fstbedfile} .bed).${PREFIX}genes.gtf
