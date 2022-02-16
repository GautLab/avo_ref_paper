# This script makes .bed files for the top 1% windows, then intersects the windows with the .gff file
cd /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/SweeD_output
for i in $(cat /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/pops.list) 
do 
    sort -k 3 -r -g allchrs.${i}.10k.SweeD.txt | head -n 1300 | sed 's/chr/Chr/g' | awk -v OFS='\t' '{print $1, (int($2 - 5000)<0)?0:int($2 - 5000), int($2 + 5000)}' > allchrs.${i}.10k.SweeD.top1.bed
    bedtools intersect -wa -f 0.1 -a /gpool/shared/avocados/scaffolds/filtered_genes/gwen.scaffolds.genes.012422.bed -b allchrs.${i}.10k.SweeD.top1.bed | sort -u -k4,4 > allchrs.${i}.10k.SweeD.top1.genes.bed
done
