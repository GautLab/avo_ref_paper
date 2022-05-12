#!/bin/bash
#PREFIX=top15xsomes
PREFIX=allcontigs

head -n 1 $(ls avocado*tig*.PL | head -n 1) > avocado.haplo.noOG.recodeall.maf.recode.${PREFIX}.BEAGLE.PL
for i in $(ls avocado*tig*.PL)
   do grep -v marker $i >> avocado.haplo.noOG.recodeall.maf.recode.${PREFIX}.BEAGLE.PL
done
