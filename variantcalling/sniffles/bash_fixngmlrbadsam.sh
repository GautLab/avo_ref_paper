#!/bin/bash

zcat gwen_scaffolds_20kb_pbreads.ngmlr.test.sam.gz | awk -F "\t" '{if ($5 >= 0 || substr ($1, 0, 1)=="@") print $0}' > gwen_scaffolds_20kb_pbreads.ngmlr.clean.sam
