#!/bin/bash
#SBATCH -J bwagl		# jobname
#SBATCH -o bwagl.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e bwagl.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-13			# start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p RM			# queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin	# email me when the job starts
#SBATCH --mail-type=end		# email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

PATH=/home/solares/bin/bwa-0.7.17/:$PATH

REF=$1
i=${SLURM_ARRAY_TASK_ID}


###gautlab samples
#JOBFILE1="gautlabsamples.txt"
#JOBFILE2="gautlabsamplefns.txt"
#QRY1A="$(head -n $(($i*4-3)) ${JOBFILE2} | tail -n 1)"
#QRY1B="$(head -n $(($i*4-2)) ${JOBFILE2} | tail -n 1)"
#QRY2A="$(head -n $(($i*4-1)) ${JOBFILE2} | tail -n 1)"
#QRY2B="$(head -n $(($i*4)) ${JOBFILE2} | tail -n 1)"
#QRY1A=illumina/$(basename $QRY1A -READ1-Sequences.txt.gz)_1
#QRY1B=illumina/$(basename $QRY1B -READ1-Sequences.txt.gz)_1
#QRY2A=illumina/$(basename $QRY2A -READ2-Sequences.txt.gz)_2
#QRY2B=illumina/$(basename $QRY2B -READ2-Sequences.txt.gz)_2

###hass study samples and other study
JOBFILE1="hasssamples.txt"
JOBFILE2="hasssamplefns.txt"
QRY1=$(head -n $(($i*2-1)) ${JOBFILE2} | tail -n 1)
QRY2=$(head -n $(($i*2)) ${JOBFILE2} | tail -n 1)
QRY1="illumina/$(basename $QRY1 .fastq.gz)"
QRY2="illumina/$(basename $QRY2 .fastq.gz)"

PAIRED="_paired_trimm.fastq.gz"
UNPAIRED="_unpaired_trimm.fastq.gz"

OPTIONS="-t ${SLURM_CPUS_ON_NODE}"
PREFIX=$(head -n $i ${JOBFILE1} | tail -n 1 | awk '{print $1}')

echo "Starting alignment for ${PREFIX} on ${REF}"
###bwa mem -M ${OPTIONS} $REF $QRY1A $QRY2A $QRY1B QRY2B > $(basename ${REF} .fasta)_${PREFIX}.sam

###HASS
bwa mem -M ${OPTIONS} $REF ${QRY1}${PAIRED} ${QRY2}${PAIRED} > $(basename ${REF} .fasta)_${PREFIX}.sam
###GAUTLAB
#bwa mem -M ${OPTIONS} $REF ${QRY1A}${PAIRED} ${QRY2A}${PAIRED} > $(basename ${REF} .fasta)_${PREFIX}A.sam
#bwa mem -M ${OPTIONS} $REF ${QRY1B}${PAIRED} ${QRY2B}${PAIRED} > $(basename ${REF} .fasta)_${PREFIX}B.sam
