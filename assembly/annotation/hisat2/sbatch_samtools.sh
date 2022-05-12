#!/bin/bash
#SBATCH -J samtoolspe		# jobname
#SBATCH -o samtoolspe.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolspe.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 10-10	#10, 17		# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 16
###SBATCH --mem-per-cpu=4000
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end		# email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  SLURM_CPUS_ON_NODE
#  SLURM_CPUS_PER_TASK
#  SLURM_ARRAY_TASK_ID

###samtools 1.10
PATH=/gpool/bin/samtools-1.10/bin:$PATH

JOBFILE=pelibs.txt
MYLIB=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1).PE
#JOBFILE=selibs.txt
#MYLIB=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1).SE

samtools view -bS ${MYLIB}.sam | samtools sort -@ ${SLURM_CPUS_PER_TASK} -o ${MYLIB}.sorted.bam
