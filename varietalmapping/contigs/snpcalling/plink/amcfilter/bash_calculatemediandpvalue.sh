#!/bin/bash

PATH=/gpool/bin/bcftools-1.11/bin:$PATH

MYVCF=avocado.haplo.clean.vcf.gz

#bcftools query -f '%CHROM\t%POS\t%INFO/DP\n' ${MYVCF} > DP_values.txt
#MEDIANDPLINE=$(($(wc -l DP_values.txt | awk '{print $1}')/2))
#echo $MEDIANDPLINE
MEDIANDPVAL=$(($(sort -rnk 3,3 DP_values.txt | awk '{if(NR==59989242) print $0}' | awk '{print $3}')*3))
echo MEDIANDPVAL
#scaffolds original vcf
#median line 59170664
#median line value 1719
#median line 26370946
#median line value
#contigs original vcf
#median line 59989242
#median line value 1662
bcftools filter --threads 11 -e "QD < 2.0 | FS > 60.0 | MQ < 40.0 | MQRankSum < -12.5 | ReadPosRankSum < -8.0 | SOR > 3.0 |  INFO/DP < 5 | INFO/DP > ${MEDIANDPVAL}" ${MYVCF} > $(basename ${MYVCF} .vcf.gz).amcfilter.vcf
##bcftools filter --threads 11 -e "QD < 2.0 | FS > 60.0 | MQ < 40.0 | MQRankSum < -12.5 | ReadPosRankSum < -8.0 | SOR > 3.0 |  INFO/DP < 5 | INFO/DP > 1563" gwen_avocado.scaffolds.haplo.noBAD.recodeall.maf.recode.sorted.vcf.gz > gwen_avocado.scaffolds.haplo.noBAD.recodeall.maf.recode_amcfilter.vcf
