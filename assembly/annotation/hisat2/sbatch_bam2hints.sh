#!/bin/bash
#SBATCH -J bam2hints		# jobname
#SBATCH -o bam2hints.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e bam2hints.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 2
###SBATCH --mem-per-cpu=4000
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end		# email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

#source ~/.conda3rc
#conda activate augustus20201116
###Augustus 3.3.3 2020-11-18
PATH=/networkshare/bin/Augustus/auxprogs/bam2wig:$PATH
PATH=/networkshare/bin/Augustus/auxprogs/bam2hints:$PATH
PATH=/networkshare/bin/Augustus/bin:$PATH
PATH=/networkshare/bin/Augustus/scripts:$PATH
PATH=/networkshare/bin/Augustus/config:$PATH
AUGUSTUS_CONFIG_PATH=/networkshare/bin/Augustus/config:$PATH
export AUGUSTUS_CONFIG_PATH=/networkshare/bin/Augustus/config/
export TOOLDIR=/networkshare/bin/Augustus/auxprogs/toolsdir

SPECIES=arabidopsis
PROTEINFILE=Trinity.fasta.transdecoder.pep
CDSFILE=Trinity.fasta.transdecoder.cds
REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta
INPUTFILE=avocado.merged.bam
PREFIX=$(basename $REF .fasta)_$(basename ${INPUTFILE} .bam)

bam2hints --in=${INPUTFILE} --out=${PREFIX}.hints.gff
