#!/bin/bash

PATH=/gpool/bin/bedtools2/bin:$PATH

#BAM=gwen_scaffolds.typeA.sorted.bam
BAM=gwen_scaffolds.typeB.sorted.bam
GENES=gwen.scaffolds.genes.012422.genes.gff3

bedtools bamtobed -i ${BAM} > $(basename ${BAM} .sorted.bam).bed

#bedtools intersect -a gwen_scaffolds.DEL.precise.clean.bed -b gwen.scaffolds.genes.012422.genes.gtf > gwen_scaffolds.DEL.precise.genes.bed

sort -k1,1V -k2,2n $(basename ${BAM} .sorted.bam).bed > $(basename ${BAM} .sorted.bam).sorted.bed

bedtools coverage -sorted -a ${GENES} -b $(basename ${BAM} .bam).bed > $(basename ${BAM} .sorted.bam).genes.coverage

bedtools coverage -d -sorted -a ${GENES} -b $(basename ${BAM} .sorted.bam).sorted.bed > $(basename ${BAM} .sorted.bam).genes.nt.coverage
