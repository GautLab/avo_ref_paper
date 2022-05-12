#!/bin/bash

for i in $(ls *.fst)
  do tail -n +2 $i | sort -k1,1V -k2,2n > $(basename $i .fst).bed
done
