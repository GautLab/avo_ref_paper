#!/bin/bash
#SBATCH -J 12gatkvariantcalling
#SBATCH -o gatkvariantcalling.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gatkvariantcalling.e%A.%a   # error file name
#SBATCH -a 1-36                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem-per-cpu=30000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

### arg1 $1 = Chromosome

#gatk 3.7
GATKDIR=/gpool/bin/gatk
PATH=/gpool/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/gpool/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/gpool/bin/jre1.8.0_221/
export JRE_HOME=/gpool/bin/jre1.8.0_221/
#picard tools
PICARDDIR=/gpool/bin/picardtools-2.24.1
###samtools 1.10
PATH=/gpool/bin/samtools-1.10/bin:$PATH
#vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH

JOBFILE=sortedbams.txt
#REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta
#REF=pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary.fasta
REF=gwen_scaffolds.fasta

### BAM=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_CarlsbadA_sorted.bam
BAM=$1_$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
BAMPREFIX=$(basename ${BAM} _sorted.bam)
JAVACALL="java -Xmx30g -jar"

PICARDLOC=$PICARDDIR
GATKLOC=$GATKDIR
OUTPREFIX=$1_$(basename ${REF} .fasta)
###Realigning and indel calling
###Requires PREFIX_indel.recode.vcf from sbatch_callvariants.sh
#JAVACALL="java -Xmx30g -jar"
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T RealignerTargetCreator -R ${REF} -I ${BAMPREFIX}_1_sorted.bam -known ${OUTPREFIX}_indel.recode.vcf -o ${BAMPREFIX}_realigner.intervals
###echo ${HSRUN}
###env time -f "Time: %E, max RAM: %M CPU: %P" -o gatk_realignertarget_job${SLURM_CPUS_PER_TASK}.txt -v $HSRUN
###${HSRUN}

###More realigning
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T IndelRealigner -R ${REF} -I ${BAMPREFIX}_1_sorted.bam -targetIntervals ${BAMPREFIX}_realigner.intervals -known ${OUTPREFIX}_indel.recode.vcf -o ${BAMPREFIX}_realigner.bam
###echo ${HSRUN}
###env time -f "Time: %E, max RAM: %M CPU: %P" -o gatk_indelrealigner_job${SLURM_CPUS_PER_TASK}.txt -v $HSRUN

###Base recalibration
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T BaseRecalibrator -R ${REF} -I ${BAMPREFIX}_realigner.bam -knownSites ${OUTPREFIX}.flt.vcf -o ${BAMPREFIX}_recal_data.table

###no clue print reads maybe
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T PrintReads -R ${REF} -I ${BAMPREFIX}_realigner.bam -BQSR ${BAMPREFIX}_recal_data.table -o ${BAMPREFIX}_recal.bam

#Haplotype caller
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF} -T HaplotypeCaller -I ${BAMPREFIX}_1_sorted.bam -o ${BAMPREFIX}.g.vcf --output_mode EMIT_ALL_SITES -ERC GVCF
#${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF} -T HaplotypeCaller -I ${BAMPREFIX}.bam -o ${BAMPREFIX}.g.vcf --output_mode EMIT_ALL_SITES -ERC GVCF

####sample
####${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF}

