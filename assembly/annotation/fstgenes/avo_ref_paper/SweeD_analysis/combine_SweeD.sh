# This script combines the SweeD reports for each chromosome to make a single file for each population
for i in $(cat pops.list) 
do 
    for z in 1 2 3 4 5 6 7 8 9 10 11 12 U
    do 
        cd ${i}/
        cat SweeD_Report.${i}.10k.Chr${z}  | grep -v "Likelihood" | sed "s/^/chr${z}\t/"  >> allchrs.${i}.10k.SweeD.txt 
        cd ../  
    done
done 

