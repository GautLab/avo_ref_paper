#!/bin/bash

for i in $(ls *.fastq)
do
   pigz ${i}
done
