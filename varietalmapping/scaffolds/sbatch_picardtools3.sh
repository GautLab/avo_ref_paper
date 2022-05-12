#!/bin/bash
#SBATCH -J picardtools
#SBATCH -o picardtools.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e picardtools.e%A.%a   # error file name
#SBATCH -a 17-17		# 1-36
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem-per-cpu=120000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

#gatk 3.7
GATKDIR=/gpool/bin/gatk
PATH=/gpool/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/gpool/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/gpool/bin/jre1.8.0_221/
export JRE_HOME=/gpool/bin/jre1.8.0_221/
#picard tools
PICARDDIR=/gpool/bin/picardtools-2.24.1
###samtools 1.11
PATH=/gpool/bin/samtools-1.11/bin:$PATH
#vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH

JOBFILE=sortedbamfiles.txt
#REF=$1

### BAM=pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary_Carlsbad.merged_sorted.bam
BAM=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
BAMPREFIX=$(basename ${BAM} .bam)
JAVACALL="java -Xmx120g -jar"

PICARDLOC=$PICARDDIR
GATKLOC=$GATKDIR

### _sorted.bam to _sorted_dup.bam
HSRUN="${JAVACALL} ${PICARDLOC}/picard.jar MarkDuplicates I=${BAM} M=${BAMPREFIX}_dup_metrics.txt O=${BAMPREFIX}_dup.bam REMOVE_DUPLICATES=true"
echo ${HSRUN}
env time -f "Time: %E, max RAM: %M CPU: %P" -o picard_markdupes_job${SLURM_ARRAY_TASK_ID}.txt -v $HSRUN

### _sorted.bam to sorted_dup.bam.bai
samtools index ${BAMPREFIX}_dup.bam

### _sorted.bam to _sorted_1.bam
HSRUN="${JAVACALL} ${PICARDLOC}/picard.jar AddOrReplaceReadGroups I=${BAMPREFIX}_dup.bam o=${BAMPREFIX}_1.bam SORT_ORDER=coordinate RGID=${BAMPREFIX} RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=${BAMPREFIX}"
echo ${HSRUN}
env time -f "Time: %E, max RAM: %M CPU: %P" -o picard_addorreplacegroups_job${SLURM_ARRAY_TASK_ID}.txt -v $HSRUN

### _sorted.bam to _sorted_1.bam.bai
samtools index ${BAMPREFIX}_1.bam
