#!/bin/bash

for i in $(ls *.outfmt6)
  do
      awk '{print $2}' ${i} | cut -d"|" -f2 | sort | uniq > $(basename ${i} .outfmt6).genelist
done
