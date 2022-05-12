#!/bin/bash
#SBATCH -J calcpid             # jobname
#SBATCH -o calcpid.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e calcpid.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-55          # start and stop of the array start-end
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p RM-shared           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 24:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

#module load samtools/1.9

JOBFILE="samfiles.txt"
i=${SLURM_ARRAY_TASK_ID}
SAMFILE=$(head -n $i $JOBFILE | tail -n 1)

i=$(basename $SAMFILE .sam.gz)_mapq_scores.txt
echo $i
awk '{printf "%.0f %.4f\n", ($4 / $7), $7}' $i | awk '{print ($1 * $2), $1}' | awk '{suma+=$1; sumb+=$2;} END {printf "%.4f %.0f\n", suma, sumb}' | awk '{print $1 / $2}'
