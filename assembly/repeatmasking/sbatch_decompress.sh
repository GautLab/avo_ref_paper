#!/bin/bash
#SBATCH -J repeatmodeler                # jobname
#SBATCH -o repeatmodeler.o%A.%a         # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e repeatmodeler.e%A.%a         # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1                    # start and stop of the array start-end
#SBATCH -A mcb190095p
###SBATCH --nodes=1
#SBATCH -n 1
#SBATCH -p RM-shared           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=5000
#SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end         # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK

tar xzvf firstrun.tar.gz
