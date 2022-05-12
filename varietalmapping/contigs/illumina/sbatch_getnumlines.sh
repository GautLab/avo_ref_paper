#!/bin/bash
#SBATCH -J pamlcs             # jobname
#SBATCH -o pamlcs.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e pamlcs.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-21          # start and stop of the array start-end
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p RM-shared           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 00:30:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE


JOBFILE1=gautlabsamples.txt
JOBFILE2=gautlabsamplefns.txt
OUTFILE=gautlablinecounts.txt
i=${SLURM_ARRAY_TASK_ID}
echo $(head -n $i ${JOBFILE1} | tail -n 1 | awk '{print $1}') $(($(echo $(zcat $(head -n $(($i*4-3)) ${JOBFILE2} | tail -n 1) | wc -l | awk '{print $1}'))/4)) $(($(echo $(zcat $(head -n $(($i*4-2)) ${JOBFILE2} | tail -n 1) | wc -l | awk '{print $1}'))/4)) $(($(echo $(zcat $(head -n $(($i*4-1)) ${JOBFILE2} | tail -n 1) | wc -l | awk '{print $1}'))/4)) $(($(echo $(zcat $(head -n $(($i*4)) ${JOBFILE2} | tail -n 1) | wc -l | awk '{print $1}'))/4)) >> ${OUTFILE}
