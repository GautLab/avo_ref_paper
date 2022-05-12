#!/bin/bash

bcftools query -f '%CHROM\t%POS\t%INFO/DP\n' gwen_avocado.scaffolds.haplo.noBAD.recodeall.maf.recode.vcf.gz > DP_values.txt
MEDIANDPLINE=$(($(wc -l DP_values.txt | awk '{print $1}')/2))
MEDIANDPVAL=$(($(sort -rnk 3,3 DP_values.txt | awk '{if(NR==26370946) print $0}' | awk '{print $3}')*3))
#59170664
#1719
bcftools filter --threads 11 -e "QD < 2.0 | FS > 60.0 | MQ < 40.0 | MQRankSum < -12.5 | ReadPosRankSum < -8.0 | SOR > 3.0 |  INFO/DP < 5 | INFO/DP > ${MEDIANDPVAL}" gwen_avocado.scaffolds.haplo.noBAD.recodeall.maf.recode.vcf.gz > gwen_avocado.scaffolds.haplo.noBAD.recodeall.maf.recode_amcfilter.vcf.gz
#bcftools filter --threads 11 -e "QD < 2.0 | FS > 60.0 | MQ < 40.0 | MQRankSum < -12.5 | ReadPosRankSum < -8.0 | SOR > 3.0 |  INFO/DP < 5 | INFO/DP > 1563" gwen_avocado.scaffolds.haplo.noBAD.recodeall.maf.recode.sorted.vcf.gz > gwen_avocado.scaffolds.haplo.noBAD.recodeall.maf.recode_amcfilter.vcf
