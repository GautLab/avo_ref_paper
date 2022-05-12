#!/bin/bash
#RNA-seq of Persea americana
#PRJNA412534
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116327
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116328
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116329
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116330
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116331
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116332
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116333
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR6116334
#Persea americana var. drymifolia: RNA-Seq Mixed library (organs and ripening stages)
#PRJNA282441
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR2000042
#Avocado fruit pulp transcriptomes: friut sample from Persea americana Mill.
#PRJNA391003
fastq-dump --defline-seq '@$sn[_$rn]/$ri' --split-files SRR5738276
#Persea americana mesocarp Stage I-VII
#PRJNA253536
fastq-dump --defline-seq '@$sn[_$rn]/$ri' SRR1463351
fastq-dump --defline-seq '@$sn[_$rn]/$ri' SRR1463350
fastq-dump --defline-seq '@$sn[_$rn]/$ri' SRR1463349
fastq-dump --defline-seq '@$sn[_$rn]/$ri' SRR1463348
fastq-dump --defline-seq '@$sn[_$rn]/$ri' SRR1463346
fastq-dump --defline-seq '@$sn[_$rn]/$ri' SRR1463344
fastq-dump --defline-seq '@$sn[_$rn]/$ri' SRR1463340
