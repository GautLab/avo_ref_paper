#!/bin/bash
#SBATCH -J hassminimap2		# jobname
#SBATCH -o hassminimap2.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e hassminimap2.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-5			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 1
#SBATCH --mem-per-cpu=20000
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end		# email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

PATH=/gpool/bin/minimap2:$PATH

JOBFILE=features.txt
FEATURE=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=pamer.contigs.c21.consensus.consensus_pilon_pilon.masked.fasta
#REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta

minimap2 -ax splice:hq -uf ${REF} ${FEATURE} > $(basename $REF .fasta)_$(basename $FEATURE .fasta)_wholeasm.sam
