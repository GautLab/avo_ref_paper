#!/bin/bash

FSTGTF=$1

awk '{print $1":"$4"-"$5"\t"$9}' ${FSTGTF} > $(basename ${FSTGTF} .gtf).mappedgenelist
awk '{print $9}' ${FSTGTF} > $(basename ${FSTGTF} .gtf).genelist
awk '{print $1":"$4"-"$5}' ${FSTGTF} > $(basename ${FSTGTF} .gtf).bedgeneids
