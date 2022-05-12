#!/bin/bash

MYBED=$1

sort -k1,1V -k2,2n ${MYBED} > $(basename ${MYBED} .bed).sorted.bed
