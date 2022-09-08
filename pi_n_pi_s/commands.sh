# Put fasta and gff file in snpeff/data/gwen so that snpeff can read them
# Build database
java -jar ./snpEff.jar build -gff3 -noCheckProtein -noCheckCds -v gwen
java -jar ./snpEff.jar build -gff3 -noCheckProtein -noCheckCds -v gwen2 # 20k intersect

# Run annotations
# See job files in this directory

# Make bed file for exons - all exons
grep -v "^#" gwen.scaffolds.genes.012422.gff3 | awk '$3 == "exon" {print $0}' | awk -v OFS='\t' '{print $1,$4,$5}' > /gpool/swyant/software/snpEff/gwen.scaffolds.exons.012422.bed

sort -k1,1V -k2,2n gwen.scaffolds.exons.012422.bed > gwen.scaffolds.exons.sorted.012422.bed

bedtools merge -i gwen.scaffolds.exons.sorted.012422.bed > gwen.scaffolds.exons.sorted.merged.012422.bed

# Tally total exon length in base pairs
cat gwen.scaffolds.exons.sorted.merged.012422.bed | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}'
#47752072 gwen all exons

# Make bed file for exons - 20k intersect
grep -v "^#" /gpool/shared/avocados/scaffolds/pnasintersection/gwen.scaffolds.20kNs.gene.annotation.exon.sorted.merged.sorted.pnas.mergedbeforegrep.gff | awk '$3 == "exon" {print $0}' | awk -v OFS='\t' '{print $1,$4,$5}' > /gpool/swyant/software/snpEff/gwen2.bed

sort -k1,1V -k2,2n gwen2.bed > gwen2.sorted.bed

bedtools merge -i gwen2.sorted.bed > gwen2.sorted.merged.bed
# Tally total exon length in base pairs
cat gwen2.sorted.merged.bed | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=$3-$2 }END{print SUM}'
#33380463 gwen 20k intersect

# Filter vcf to only biallelic snps in exon regions
bcftools view mexican.ann.vcf -O z -o mexican.ann.vcf.gz

bcftools index mexican.ann.vcf.gz

bcftools view mexican.ann.vcf.gz -R gwen.scaffolds.exons.sorted.merged.012422.bed -v snps -m2 -M2 -O v -o mexican.exons.ann.vcf

# Separate by syn / nonsyn

java -jar SnpSift.jar filter "ANN[0].EFFECT has 'missense_variant'" mexican.exons.ann.vcf > mexican.exons.nonsyn.ann.vcf

java -jar SnpSift.jar filter "ANN[0].EFFECT has 'synonymous_variant'" mexican.exons.ann.vcf > mexican.exons.syn.ann.vcf

# Run vcftools for pi
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH
vcftools --vcf mexican.exons.syn.ann.vcf --site-pi --out mexican.syn
tail -n +2 mexican.syn.sites.pi | grep -v "nan" | awk '{ sum += $3 } END { print sum }'
# 45116.6/47752072 = 0.00094480926

# Nonsyn
vcftools --vcf mexican.exons.nonsyn.ann.vcf --site-pi --out mexican.nonsyn
tail -n +2 mexican.nonsyn.sites.pi | grep -v "nan" | awk '{ sum += $3 } END { print sum }'
# 65586.9/47752072 = 0.00137348804
