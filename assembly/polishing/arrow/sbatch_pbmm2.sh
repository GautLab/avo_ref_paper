#!/bin/bash
#SBATCH -J pbmm2		# jobname
#SBATCH -o pbmm2.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e pbmm2.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 8		# start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p RM		# queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin	# email me when the job starts
#SBATCH --mail-type=end	# email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

source ~/.pbbiocondarc
conda activate smrttools

JOBFILE="references.txt"

SEED=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=${SEED}
QRY=input.fofn
OPTIONS="-j 20 -J 7"

#usage pbmm2 index ref.fasta ref.mmi
pbmm2 index ${REF} $(basename ${REF} .fasta).mmi

#usage pbmm2 align ref.mmi movie.subreads.bam ref.movie.bam
#pbmm2 align ${OPTIONS} $(basename ${REF} .fasta).mmi ${QRY} ${REF}_pbmm2.bam
pbmm2 align $(basename ${REF} .fasta).mmi ${QRY} $(basename ${REF} .fasta)_pbmm2.bam

wait
