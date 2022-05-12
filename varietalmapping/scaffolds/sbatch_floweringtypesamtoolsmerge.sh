#!/bin/bash
#SBATCH -J samtoolsmerge
#SBATCH -o samtoolsmerge.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsmerge.e%A.%a   # error file name
#SBATCH -a 1-2                  # 24
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 16
#SBATCH --mem-per-cpu=7500
#SBATCH -p urgent,p1,gcluster     # queue (partition) -- normal, development, largemem, etc.
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

JOBFILE=ftmergejobs.txt

BAMLIST=$(head -n ${i} ${JOBFILE} | tail -n 1)

LOCAL="./"
TEMPDIR=${LOCAL}_$(basename ${BAMLIST} .txt)_${SLURM_ARRAY_TASK_ID}
SORTOPTS="--threads ${CORES} -m 3G -T ${TEMPDIR}"

BAMFILE=gwen_scaffolds.$(basename ${BAMLIST} bams.txt).bam

samtools merge -@ ${CORES} ${BAMFILE} $(cat ${BAMLIST})

samtools index -b ${BAMFILE} $(basename ${BAMFILE} .bam).bai
samtools idxstats ${BAMFILE} > $(basename ${BAMFILE} .bam).stats.txt

mkdir -p ${LOCAL}
mkdir -p ${TEMPDIR}
### _merged.bam to _merged_sorted.bam
samtools sort ${OPTIONS} ${SORTOPTS} ${BAMFILE} -o $(basename ${BAMFILE} .bam).sorted.bam
rm -rf ${TEMPDIR}
### _merged_sorted.bam to _merged_sorted.bai
samtools index -b $(basename ${BAMFILE} .bam).sorted.bam $(basename ${BAMFILE} .bam).sorted.bai
