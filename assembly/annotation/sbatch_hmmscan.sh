#!/bin/bash
#SBATCH -J hmmscan		# jobname
#SBATCH -o hmmscan.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e hmmscan.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 8
#SBATCH --mem-per-cpu=2500
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end		# email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK

CORES=${SLURM_CPUS_PER_TASK}

PATH=/gpool/bin/hmmer-3.1b2-linux-intel-x86_64/binaries:$PATH

MYQRY=pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.pep
MYDB=/gpool/databases/Pfam/Pfam-A.hmm
OUTFILE=pfam.domtblout

hmmscan --cpu ${CORES} --domtblout ${OUTFILE} ${MYDB} ${MYQRY}
