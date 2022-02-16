# This script intersects the .bed files for the top 1% windows with the .gff file
cd /gpool/swyant/projects/avo_ref_paper/Fst_analysis
for i in $(cat /gpool/swyant/projects/avo_ref_paper/Fst_analysis/fst_comparisons.list) 
do 
    tail -n +2 /gpool/shared/avocados/scaffolds/popgen/gwen_avocado.scaffolds.haplo.amcfilter.Avocado_${i}_20kb_Only_Chromosomes.top1pct.windowed.weir.fst | bedtools intersect -wa -f 0.1 -a /gpool/shared/avocados/scaffolds/filtered_genes/gwen.scaffolds.genes.012422.bed -b stdin | sort -u -k4,4 > Fst.top1pct.${i}.genes.bed
done
