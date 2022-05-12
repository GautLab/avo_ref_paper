#!/bin/bash
for i in $(ls *report.txt); do test "$(tail -n 2 ${i} | head -n 1 | grep 1440)" && echo "${i}" >> failedjobs.txt; done
for i in $(cat failedjobs.txt); do grep -n $(echo $i | cut -d"_" -f1) jobfile.txt | cut -f1 -d":" >> failedjobids.txt; done
