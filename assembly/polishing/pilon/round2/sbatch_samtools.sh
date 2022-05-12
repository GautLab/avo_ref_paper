#!/bin/bash
#SBATCH -J samtools             # jobname
#SBATCH -o samtools.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtools.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1          # start and stop of the array start-end
#SBATCH -A mcb190095p
#SBATCH -N 1
###SBATCH --ntasks-per-node=1
#SBATCH -p RM           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK

#module load samtools/1.9
#PATH=/gpool/bin/samtools-1.10/bin:$PATH
module load samtools/1.11.0

JOBFILE="references.txt"

SEED=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=${SEED}
CORES=${SLURM_CPUS_ON_NODE}
PREFIX=gwen
SAM=$(basename ${REF} .fasta)_${PREFIX}.sam
OPTIONS="--threads ${CORES}"
SORTOPTS="-m 3G -T ${LOCAL}/${SLURM_ARRAY_TASK_ID}"

samtools view ${OPTIONS} -b ${SAM} --reference ${REF} -o $(basename ${SAM} .sam).bam
pigz -p ${CORES} ${SAM}
mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAM} .sam).bam -o $(basename ${SAM} .sam)_sorted.bam
rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools index -b $(basename ${SAM} .sam)_sorted.bam $(basename ${SAM} .sam)_sorted.bai
