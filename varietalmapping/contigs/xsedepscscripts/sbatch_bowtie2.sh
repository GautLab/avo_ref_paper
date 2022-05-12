#!/bin/bash
#SBATCH -J bowtie2             # jobname
#SBATCH -o bowtie2.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e bowtie2.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-21          # start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p RM           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 72:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

PATH=/home/solares/bin/bowtie2-2.4.1-linux-x86_64:$PATH

REF=$1
i=${SLURM_ARRAY_TASK_ID}

###gautlab samples
JOBFILE1="gautlabsamples.txt"
JOBFILE2="gautlabsamplefns.txt"
QRY1="illumina/$(head -n $(($i*4-3)) ${JOBFILE2} | tail -n 1) illumina/$(head -n $(($i*4-2)) ${JOBFILE2} | tail -n 1)"
QRY2="illumina/$(head -n $(($i*4-1)) ${JOBFILE2} | tail -n 1) illumina/$(head -n $(($i*4)) ${JOBFILE2} | tail -n 1)"

###hass study samples
#JOBFILE1="hasssamples.txt"
#JOBFILE2="hasssamplefns.txt"
#QRY1="illumina/$(head -n $(($i*2-1)) ${JOBFILE2} | tail -n 1)"
#QRY2="illumina/$(head -n $(($i*2)) ${JOBFILE2} | tail -n 1)"

OPTIONS="--threads ${SLURM_CPUS_ON_NODE}"
PREFIX=$(head -n $i ${JOBFILE1} | tail -n 1 | awk '{print $1}')

echo "Starting alignment for ${PREFIX} on ${REF}"
bowtie2 $OPTIONS -x $(basename ${REF} .fasta) -1 ${QRY1} -2 ${QRY2} -S ${PREFIX}_$(basename ${REF} .fasta).sam
