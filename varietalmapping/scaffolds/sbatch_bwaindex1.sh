#!/bin/bash
#SBATCH -J bwaindex             # jobname
#SBATCH -o bwaindex.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e bwaindex.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1          # start and stop of the array start-end
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH -p p1,gcluster #RM      # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
###SBATCH -t 24:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

PATH=/gpool/bin/bwa-0.7.17:$PATH
PATH=/gpool/bin/samtools-1.11.0/bin:$PATH

#JOBFILE="chromosomes.txt"

#SEED=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=gwen_scaffolds.fasta
OPTIONS="--threads ${SLURM_CPUS_ON_NODE}"

echo ${OPTIONS}
samtools faindex ${REF}
bwa index ${REF}
