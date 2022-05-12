#!/bin/bash
#SBATCH -J hisat2se		# jobname
#SBATCH -o hisat2se.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e hisat2se.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-17 # 10, 17			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 16
###SBATCH --mem-per-cpu=4000
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end		# email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  SLURM_CPUS_ON_NODE
#  SLURM_CPUS_PER_TASK
#  SLURM_ARRAY_TASK_ID

#HiSat2 2.2.1
PATH=/networkshare/bin/hisat2-2.2.1:$PATH

#JOBFILE=pelibs.txt
JOBFILE=selibs.txt
#REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary
#REF=pamer.contigs.consensus.consensus_pilon_pilon
REF=pamer.contigs.c21.consensus.consensus_pilon_pilon.masked.fasta
MYLIB=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)

# PE
#hisat2 -x ${REF} -1 ${MYLIB}_1_paired_trimm.fastq.gz -2 ${MYLIB}_2_paired_trimm.fastq.gz -S ${MYLIB}.PE.sam -p ${SLURM_CPUS_PER_TASK} --dta
####  2>&1 | tee $l.stat

# SE
hisat2 -x ${REF} -U ${MYLIB}_unpaired_trimm.fastq.gz -S ${MYLIB}.SE.sam -p ${SLURM_CPUS_PER_TASK} --dta
