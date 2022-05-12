#!/bin/bash
#SBATCH -J hapsolopam		# jobname
#SBATCH -o hapsolopam.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e hapsolopam.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 48			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1,gcluster			# queue (partition) -- normal, development, largemem, etc.
###SBATCH --mem-per-cpu=12000
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

###SLURM_CPUS_PER_TASK=10
#STARTTIME=$(date +%s)
SECONDS=0
ITERS=1100
OUT="asms3"
FASTA="pamer.contigs.consensus.consensus_pilon_pilon_new.fasta"
PAF=$(basename ${FASTA} .fasta)_noxcustom_self_align1.paf
#PAF=$(basename ${PAF} 1.paf)2.paf
PAF=$(basename ${PAF} 1.paf)3.paf
#PAF=$(basename ${PAF} 1.paf)4.paf
BUSCOS="./contigs/busco/"
HSRUN="python hapsolo.py -t ${SLURM_CPUS_PER_TASK} -n ${ITERS} -B 5 -i ${FASTA} --paf ${PAF} -b ${BUSCOS}"
env time -f "Time: %E, max RAM: %M CPU: %P" -o t${SLURM_CPUS_PER_TASK}n${ITERS}bn5.txt -v $HSRUN
echo $HSRUN
#ENDTIME=$(date +%s)
#echo $(($ENDTIME - $STARTTIME))
echo $SECONDS
mv asms ${OUT}
