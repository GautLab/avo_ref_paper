#!/bin/bash

MYGTF=$1

sort -k1,1V -k4,4n ${MYGTF} > $(basename ${MYGTF} .gtf).sorted.gtf
