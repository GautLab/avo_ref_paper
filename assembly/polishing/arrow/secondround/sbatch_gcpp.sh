#!/bin/bash
#SBATCH -J gcpp		# jobname
#SBATCH -o gcpp.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gcpp.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 7-8		# start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p RM		# queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
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
OPTIONS="-j ${SLURM_CPUS_ON_NODE}"

#usage gcpp aligned_reads{.cmp.h5, .bam, .fofn, or .xml} -r reference{.fasta or .xml} -o variants.gff -o consensus.fasta -o consensus.fastq
gcpp ${OPTIONS} $(basename ${REF} .fasta)_pbmm2.sorted.bam -r ${REF} -o $(basename ${REF} .fasta).variants.gff,$(basename ${REF} .fasta).consensus.fasta,$(basename ${REF} .fasta).consensus.fastq

wait
