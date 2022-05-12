#!/bin/bash
#SBATCH -J stringtie		# jobname
#SBATCH -o stringtie.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e stringtie.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 48
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

#StringTie 2.1.4
PATH=/networkshare/bin/stringtie-2.1.4.Linux_x86_64:$PATH

#JOBFILE=pelibs.txt
#JOBFILE=bamfiles.txt
#MYBAM=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
MYBAM=avocado.merged.bam

stringtie -p ${SLURM_CPUS_PER_TASK} -o $(basename ${MYBAM} .sorted.bam).gtf ${MYBAM}
