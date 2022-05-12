#!/bin/bash

PATH=/gpool/bin/kentUtils/bin:${PATH}

for i in $(ls pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.*.fasta)
  do
     faTrans $i $(basename ${i} .fasta).pep
done
