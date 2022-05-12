#!/bin/bash

INFILE=$1
awk '{print $2"\t"$9"\t"$10"\t"$1}' ${INFILE} > $(basename ${INFILE} .outfmt6).bed
