#!/bin/bash

for i in $(ls *genes.*_swissprot_uniprot.blastx.outfmt6)
  do
     cat $i >> pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.swissprot_uniprot.blastx.outfmt6
done

sort -k1,1V pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.swissprot_uniprot.blastx.outfmt6
