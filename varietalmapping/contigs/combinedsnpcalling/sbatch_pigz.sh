#!/bin/bash
#SBATCH -J vcfpigz
#SBATCH -o vcfpigz.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcfpigz.e%A.%a   # error file name
#SBATCH -a 1-42                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 8
#SBATCH --mem-per-cpu=2500
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}
JOBFILE=vcfjobfile.txt

VCFFILE=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)

pigz -p ${CORES} ${VCFFILE}
