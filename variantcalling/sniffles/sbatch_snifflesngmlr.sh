#!/bin/bash
#SBATCH -J sniffngmlr		# jobname
#SBATCH -o sniffngmlr.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e sniffngmlr.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 4			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1			# queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=4000
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

CORES=${SLURM_CPUS_PER_TASK}
###SLURM_ARRAY_TASK_ID

#SOURCE MINIMAP AND SNIFFLES
#PATH=/networkshare/bin/minimap2:$PATH
PATH=/gpool/bin/minimap2-2.18_x64-linux:$PATH
#Sniffles 2021-11-29
PATH=/gpool/bin/Sniffles-master/bin/sniffles-core-1.0.12:$PATH

#alignments
#BAM=gwenscaff_realignment2pb_sorted.bam
BAM=gwen_scaffolds_20kb_pbreads.ngmlr.clean_aln.sorted.bam

sniffles -m ${BAM} -v $(basename ${BAM} .bam)_sniffles_output.vcf
