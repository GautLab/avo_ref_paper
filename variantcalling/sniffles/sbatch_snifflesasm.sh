#!/bin/bash
#SBATCH -J gwensniffasmmm2		# jobname
#SBATCH -o gwensniffasmmm2.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gwensniffasmmm2.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 2-3			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 8			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
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
#samtools v1.11
PATH=/gpool/bin/samtools-1.11/bin:$PATH

JOBFILE=jobfile.txt
QRY=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=gwen_scaffolds_20kb.fasta

PREFIX1=$(basename ${QRY} .fasta)_$(basename ${REF} .fasta)
PREFIX2=$(basename ${REF} .fasta)_$(basename ${QRY} .fasta)

#pairwise genome alignment
minimap2 --MD -ax asm5 ${REF} ${QRY} > ${PREFIX1}.sam
minimap2 --MD -ax asm5 ${QRY} ${REF} > ${PREFIX2}.sam

#samtools bam and sort and index
mkdir -p ./tmp/${PREFIX1}.sorted
samtools view -ubS ${PREFIX1}.sam | samtools sort -T ./tmp/${PREFIX1}.sorted -o ${PREFIX1}_aln.sorted.bam

mkdir -p ./tmp/${PREFIX2}.sorted
samtools view -ubS ${PREFIX2}.sam | samtools sort -T ./tmp/${PREFIX2}.sorted -o ${PREFIX2}_aln.sorted.bam

rm -rf ./tmp/${PREFIX1}.sorted ./tmp/${PREFIX2}.sorted

#sniffles
sniffles -m ${PREFIX1}_aln.sorted.bam -v ${PREFIX1}_aln.sorted.vcf --skip_parameter_estimation --min_support 1
sniffles -m ${PREFIX2}_aln.sorted.bam -v ${PREFIX2}_aln.sorted.vcf --skip_parameter_estimation --min_support 1
