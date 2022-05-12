#!/bin/bash
#SBATCH -J bam2bedc20              # jobname
#SBATCH -o bam2bedc20.o%A.%a       # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e bam2bedc20.e%A.%a       # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1                 # 12,14,15      # 1-11,16,17                    # start and stop of the array start-end
###SBATCH -n 1                  # -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 1                    # -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1,gcluster                 # queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=2500
###SBATCH -t 72:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin     # email me when the job starts
###SBATCH --mail-type=end       # email me when the job finishes

#module load bedtools2/2.29.2
PATH=/gpool/bin/bedtools2/bin:$PATH

JOBFILE=bamfiles.txt
#JOBFILE=oldbamfiles.txt
BAM=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)

bedtools bamtobed -i ${BAM} > $(basename ${BAM} .bam).bed
