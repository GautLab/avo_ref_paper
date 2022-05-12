#!/bin/bash

for i in $(ls *genes.*_swissprot_uniprot.blastp.outfmt6)
  do
     cat $i >> pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.swissprot_uniprot.blastp.outfmt6
done

sort -k1,1V pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.swissprot_uniprot.blastp.outfmt6 > pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.swissprot_uniprot.blastp.sorted.outfmt6
