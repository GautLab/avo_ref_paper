#!/bin/bash
#SBATCH -J samtoolsextract
#SBATCH -o samtoolsextract.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsextract.e%A.%a   # error file name
#SBATCH -a 1-37
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.
###SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin  # email me when the job starts
###SBATCH --mail-type=end    # email me when the job finishes

#module load samtools/1.11
PATH=/gpool/bin/samtools-1.11/bin:$PATH
#CORES=$SLURM_CPUS_ON_NODE
CORES=$SLURM_CPUS_PER_TASK

i=${SLURM_ARRAY_TASK_ID}
REF=gwen_scaffolds.fasta

#JOBFILE=sortedbamfiles.txt
#JOBFILE=uniqsortedbams.txt
JOBFILE=dupfiles.txt
#JOBFILE=_1files.txt

BAMFILE=$(head -n ${i} ${JOBFILE} | tail -n 1)

OPTIONS="--threads ${CORES}"
LOCAL="./"
TEMPDIR="${LOCAL}/${1}_${SLURM_ARRAY_TASK_ID}"
SORTOPTS="-m 3G -T ${TEMPDIR}"

#samtools view -hb ${BAMFILE} $1 > $1_$(basename ${BAMFILE} _sorted.bam).bam
samtools view -hb ${BAMFILE} $1 > $1_$(basename ${BAMFILE} _sorted_dup.bam)_dup.bam
#samtools view -hb ${BAMFILE} $1 > $1_$(basename ${BAMFILE} _sorted_1.bam)_1.bam

mkdir -p ${TEMPDIR}
#samtools sort ${OPTIONS} ${SORTOPTS} $1_$(basename ${BAMFILE} _sorted.bam).bam -o $1_${BAMFILE}
samtools sort ${OPTIONS} ${SORTOPTS} $1_$(basename ${BAMFILE} _sorted_dup.bam)_dup.bam -o $1_$(basename ${BAMFILE} _sorted_dup.bam)_dup_sorted.bam
#samtools sort ${OPTIONS} ${SORTOPTS} $1_$(basename ${BAMFILE} _sorted_1.bam)_1.bam -o $1_$(basename ${BAMFILE} _sorted_1.bam)_1_sorted.bam

rm -rf ${TEMPDIR}
#samtools index -b $1_${BAMFILE}
samtools index -b $1_$(basename ${BAMFILE} _sorted_dup.bam)_dup_sorted.bam
#samtools index -b $1_$(basename ${BAMFILE} _sorted_1.bam)_1_sorted.bam
