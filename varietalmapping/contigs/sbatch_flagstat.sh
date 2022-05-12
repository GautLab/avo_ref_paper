#!/bin/bash
#SBATCH -J stfs             # jobname
#SBATCH -o stfs.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e stfs.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 56-63          # start and stop of the array start-end
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p RM-shared           # queue (partition) -- compute, shared, large-shared, debug (30mins)
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

module load samtools/1.9

i=${SLURM_ARRAY_TASK_ID}
#REF=$1

###gautlab samples
#JOBFILE1="gautlabsamples.txt"

###hass study samples
#JOBFILE1="hasssamples.txt"
JOBFILE=samfiles.txt

PREFIX=$(basename $(head -n $i ${JOBFILE} | tail -n 1 | awk '{print $1}') .sam.gz)
BAM=${PREFIX}_sorted.bam

zcat ${PREFIX}.sam.gz | samtools flagstat | awk -F "[(|%]" 'NR == 3 {print $2}' > ${PREFIX}_flagstat.txt
