#!/bin/bash
#SBATCH -J pleumm2		# jobname
#SBATCH -o pleumm2.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e pleumm2.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 36			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1,gcluster			# queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=1750
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

#source /networkshare/.mybashrc
PATH=/networkshare/bin/minimap2:$PATH

QRY=pamer.contigs.consensus.consensus_pilon_pilon.fasta

###minimap2 -t 36 -N 5 -x asm5 ${QRY} ${QRY} > $(basename ${QRY} .fasta)_n5_asm5_self_align.paf
###minimap2 -t 36 -N 5 -x asm10 ${QRY} ${QRY} > $(basename ${QRY} .fasta)_n5_asm10_self_align.paf
minimap2 -t 36 -N 5 -x asm20 ${QRY} ${QRY} > $(basename ${QRY} .fasta)_n5_asm20_self_align.paf
minimap2 -t 36 -N 5 ${QRY} ${QRY} > $(basename ${QRY} .fasta)_n5_nox_self_align.paf
minimap2 -t 36 -k19 -w5 -A1 -B2 -O3,13 -E2,1 -s200 -z200 -N50 --min-occ-floor=100 ${QRY} ${QRY} > $(basename ${QRY} .fasta)_noxcustom00_self_align.paf
minimap2 -t 36 -P -k19 -w2 -A1 -B2 -O1,6 -E2,1 -s200 -z200 -N50 --min-occ-floor=100 ${QRY} ${QRY} > $(basename ${QRY} .fasta)_noxcustom0_self_align.paf
minimap2 -t 36 -P -G 500k -k19 -w2 -A1 -B2 -O2,4 -E2,1 -s200 -z200 -N50 --max-qlen 10000000 --min-occ-floor=100 --paf-no-hit ${QRY} ${QRY} > $(basename ${QRY} .fasta)_noxcustom1_self_align.paf
minimap2 -t 36 -P -G 500k -k19 -w2 -A1 -B2 -O1,4 -E2,1 -s200 -z200 -N50 --max-qlen 10000000 --min-occ-floor=100 --paf-no-hit ${QRY} ${QRY} > $(basename ${QRY} .fasta)_noxcustom2_self_align.paf
