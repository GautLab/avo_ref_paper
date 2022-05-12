#!/bin/bash
#SBATCH -J samtools		# jobname
#SBATCH -o samtools.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtools.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 8		# start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p RM		# queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin	# email me when the job starts
#SBATCH --mail-type=end	# email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

module load samtools/1.9

JOBFILE="references.txt"

SEED=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=${SEED}
OPTIONS="-@ ${SLURM_CPUS_ON_NODE} -m 3G -T ${LOCAL}/${SLURM_ARRAY_TASK_ID}"

mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
#usage samtools sort -m ${THREADMEM}G -@ $CPUS -o input.sorted.bam -O bam input.bam
samtools sort ${OPTIONS} -o $(basename ${REF} .fasta)_pbmm2.sorted.bam -O bam $(basename ${REF} .fasta)_pbmm2.bam
rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}

wait
