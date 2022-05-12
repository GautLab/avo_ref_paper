#!/bin/bash
#SBATCH -J gatkvariantcalling
#SBATCH -o gatkvariantcalling.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gatkvariantcalling.e%A.%a   # error file name
#SBATCH -a 1-1                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem-per-cpu=120000
#SBATCH -p gcluster,p1     # queue (partition) -- normal, development, largemem, etc.

#gatk 3.7
GATKDIR=/networkshare/bin/gatk
PATH=/gpool/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/gpool/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/gpool/bin/jre1.8.0_221/
export JRE_HOME=/gpool/bin/jre1.8.0_221/
#picard tools
PICARDDIR=/networkshare/bin/picardtools-2.24.1
###samtools 1.10
PATH=/gpool/bin/samtools-1.10/bin:$PATH
#vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH

JOBFILE=bamfiles.txt
REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta

BAM=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
BAMPREFIX=$(basename ${BAM} .bam)
JAVACALL="java -Xmx120g -jar"

PICARDLOC=$PICARDDIR
GATKLOC=$GATKDIR
OUTPREFIX=$(basename ${REF} .fasta)

HSRUN="${JAVACALL} ${PICARDLOC}/picard.jar MarkDuplicates I=${BAM} M=${BAMPREFIX}_dup_metrics.txt O=${BAMPREFIX}_dup.bam REMOVE_DUPLICATES=true"
echo $HSRUN
env time -f "Time: %E, max RAM: %M CPU: %P" -o picard_markdupes_job${SLURM_ARRAY_TASK_ID}.txt -v $HSRUN

samtools index ${BAMPREFIX}_dup.bam

HSRUN="${JAVACALL} ${PICARDLOC}/picard.jar AddOrReplaceReadGroups I=${BAMPREFIX}_dup.bam o=${BAMPREFIX}_1.bam SORT_ORDER=coordinate RGID=${BAMPREFIX} RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=${BAMPREFIX}"
echo $HSRUN
env time -f "Time: %E, max RAM: %M CPU: %P" -o picard_addorreplacegroups_job${SLURM_ARRAY_TASK_ID}.txt -v $HSRUN

samtools index ${BAMPREFIX}_1.bam

###Realigning and indel calling
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T RealignerTargetCreator -R  ${REF} -I ${BAMPREFIX}_1.bam -known ${OUTPREFIX}_indel.recode.vcf -o ${BAMPREFIX}_realigner.intervals

###More realigning
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T IndelRealigner -R ${REF} -I ${BAMPREFIX}_1.bam -targetIntervals ${BAMPREFIX}_realigner.intervals -known ${OUTPREFIX}_indel.vcf.recode.vcf -o ${BAMPREFIX}_realigner.bam

###Base recalibration
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T BaseRecalibrator -R ${REF} -I ${BAMPREFIX}_realigner.bam -knownSites ${OUTPREFIX}.flt.vcf -o ${BAMPREFIX}_recal_data.table

###no clue print reads maybe
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -T PrintReads -R ${REF} -I ${BAMPREFIX}_realigner.bam -BQSR ${BAMPREFIX}_recal_data.table -o ${BAMPREFIX}_recal.bam

#Haplotype caller
${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF} -T HaplotypeCaller -I ${BAMPREFIX}_sorted.bam -o ${BAMPREFIX}.g.vcf --output_mode EMIT_ALL_SITES -ERC GVCF

####sample
####${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF}

