#!/bin/bash
#PREFIX=top15xsomes
#PREFIX=gwen_avocado.scaffolds.haplo.noOG.recodeall.maf.recode.
PREFIX=gwen_avocado.scaffolds.haplo.amcfilter.noOG.recodeall.maf.recode.
PREFIX=${PREFIX}allcontigs

head -n 1 $(ls gwen_avocado*Chr*.PL | head -n 1) > ${PREFIX}.BEAGLE.PL
for i in $(ls gwen_avocado*Chr*.PL)
   do grep -v marker $i >> ${PREFIX}.BEAGLE.PL
done
