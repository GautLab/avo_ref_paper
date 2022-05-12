#!/bin/bash

wc -l *.filtered.genes.gtf | sed 's/_avocado//g' | sed 's/haplo.amcfilter.//g' | sed 's/_Avocado_/./g' | sed 's/Avocado_//g' | sed 's/_Only_Chromosomes//g' | sed 's/windowed.weir.//g'
