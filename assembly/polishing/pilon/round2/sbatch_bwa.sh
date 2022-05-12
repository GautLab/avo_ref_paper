#!/bin/bash
#SBATCH -J bwagl		# jobname
#SBATCH -o bwagl.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e bwagl.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1			# start and stop of the array start-end
#SBATCH -A mcb190095p
#SBATCH --nodes=1
###SBATCH -c 48
#SBATCH -p RM		# queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin	# email me when the job starts
#SBATCH --mail-type=end		# email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

#PATH=/networkshare/bin/bwa-0.7.17:$PATH
module load BWA/0.7.3a

REF=$(head -n ${SLURM_ARRAY_TASK_ID} references.txt | tail -n 1)

###gautlab samples
QRY1A=rawdata/illumina/gautlab/gwen_illumina_R1.fastq
QRY2A=rawdata/illumina/gautlab/gwen_illumina_R2.fastq
PREFIX="gwen"

OPTIONS="-t ${SLURM_CPUS_ON_NODE}"

echo "Starting alignment for ${PREFIX} on ${REF}"
###bwa mem -M ${OPTIONS} $REF $QRY1A $QRY2A $QRY1B QRY2B > $(basename ${REF} .fasta)_${PREFIX}.sam

###GAUTLAB
bwa mem -M ${OPTIONS} $REF ${QRY1A} ${QRY2A} > $(basename ${REF} .fasta)_${PREFIX}.sam
