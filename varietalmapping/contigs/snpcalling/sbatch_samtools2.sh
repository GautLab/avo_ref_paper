#!/bin/bash
#SBATCH -J samtoolsmergeidx
#SBATCH -o samtoolsmergeidx.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsmergeidx.e%A.%a   # error file name
#SBATCH -a 7			# 24
###SBATCH -N 1			# Total number of nodes requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 16
#SBATCH --mem-per-cpu=5000
#SBATCH -p p1,gcluster			# queue (partition) -- normal, development, largemem, etc.
#SBATCH -t 12:00:00		# run time (hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin  # email me when the job starts
###SBATCH --mail-type=end    # email me when the job finishes

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK

#CORES=${SLURM_CPUS_ON_NODE}
CORES=${SLURM_CPUS_PER_TASK}

PATH=/gpool/bin/samtools-1.11/bin:$PATH
#module load samtools/1.11.0

JOBFILE=bamstomerge.txt

BAMFILEA=$(head -n $((2*${SLURM_ARRAY_TASK_ID}-1)) ${JOBFILE} | tail -n 1)
BAMFILEB=$(head -n $((2*${SLURM_ARRAY_TASK_ID})) ${JOBFILE} | tail -n 1)
BAMFILE=$(basename ${BAMFILEA} A_sorted.bam).merged.bam
LOCAL="./"
SORTOPTS="-m 3G -T ${LOCAL}/${SLURM_ARRAY_TASK_ID}"

samtools merge -@ ${SLURM_CPUS_ON_NODE} ${BAMFILE} ${BAMFILEA} ${BAMFILEB}
samtools index -b ${BAMFILE} $(basename ${BAMFILE} .bam).bai
samtools idxstats ${BAMFILE} > $(basename ${BAMFILE} .bam)_stats.txt

mkdir -p ${LOCAL}
mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
### _merged.bam to _merged_sorted.bam
samtools sort ${OPTIONS} ${SORTOPTS} ${BAMFILE} -o $(basename ${BAMFILE} .bam)_sorted.bam
rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}
### _merged_sorted.bam to _merged_sorted.bai
samtools index -b $(basename ${BAMFILE} .bam)_sorted.bam $(basename ${BAMFILE} .bam)_sorted.bai
