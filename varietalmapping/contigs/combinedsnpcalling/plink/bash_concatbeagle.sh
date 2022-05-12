#!/bin/bash
#PREFIX=top15xsomes
PREFIX=allcontigs

head -n 1 $(ls BEAGLEfiles/avocado*tig*.PL | head -n 1) > avocado.haplo.noOG.recodeall.maf.recode.${PREFIX}.BEAGLE.PL
for i in $(ls BEAGLEfiles/avocado*tig*.PL)
   do grep -v marker $i >> avocado.haplo.noOG.recodeall.maf.recode.${PREFIX}.BEAGLE.PL
done
