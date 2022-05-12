#!/bin/bash
#SBATCH -J gwenmm2		# jobname
#SBATCH -o gwenmm2.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gwenmm2.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 24			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1,gcluster			# queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=2500
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

CORES=${SLURM_CPUS_PER_TASK}
###SLURM_ARRAY_TASK_ID

#PATH=/networkshare/bin/minimap2:$PATH
PATH=/gpool/bin/minimap2-2.18_x64-linux:$PATH

#REF=pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta
#REF=pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary.fasta
REF=gwen_scaffolds_20kb.fasta

QRY=pacbio/gwen_pacb_subreads.fastq.gz
#PREFIX=gwenhs_realignment
PREFIX=gwenscaff_realignment

# minimap2 -ax map-pb  ref.fa pacbio-reads.fq > aln.sam
minimap2 -t ${CORES} --MD -ax map-pb ${REF} ${QRY} > ${PREFIX}2pb.MD.sam


#QRY1=illumina/gwen_illumina_R1.fastq
#QRY2=illumina/gwen_illumina_R2.fastq
#PREFIX=gwenhs_realignment_illumina

# minimap2 -ax sr ref.fa read1.fa read2.fa > aln.sam
#minimap2 -t ${CORES} --MD -ax sr ${REF} ${QRY1} ${QRY2} > ${PREFIX}2sr.sam
