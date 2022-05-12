#!/bin/bash
#SBATCH -J blat		# jobname
#SBATCH -o blat.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e blat.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -c 2
#SBATCH -p gcluster,p1		# queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin	# email me when the job starts
#SBATCH --mail-type=end		# email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

#module load blat/v35
PATH=/networkshare/bin/blat:$PATH

PROTEINFILE=Trinity.fasta.transdecoder.pep
CDSFILE=Trinity.fasta.transdecoder.cds
#REF=pamer.contigs.consensus.consensus_pilon_pilon.fasta
#REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta
REF=pamer.contigs.c21.consensus.consensus_pilon_pilon.masked.fasta

blat -minIdentity=92 $REF $CDSFILE $(basename $REF .fasta)_$(basename $CDSFILE .cds).psl
