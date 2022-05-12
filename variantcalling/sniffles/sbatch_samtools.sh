#!/bin/bash
#SBATCH -J ngmlrsamtools		# jobname
#SBATCH -o ngmlrsamtools.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e ngmlrsamtools.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 16			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1			# queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=2500
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

CORES=${SLURM_CPUS_PER_TASK}
###SLURM_ARRAY_TASK_ID

# samtools 1.11
PATH=/gpool/bin/samtools-1.11/bin:$PATH

#SAM=gwen_scaffolds_20kb_pbreads.ngmlr.test.sam
SAM=gwen_scaffolds_20kb_pbreads.ngmlr.clean.sam
REF=gwen_scaffolds_20kb.fasta

PREFIX=$(basename ${SAM} .sam)

OPTIONS="--threads ${CORES}"
LOCAL="./"
TEMPDIR="${LOCAL}/${REF}_GLAB_${SLURM_ARRAY_TASK_ID}"
SORTOPTS="-m 3G -T ${TEMPDIR}"

samtools view ${OPTIONS} -b ${SAM} --reference ${REF} -o ${PREFIX}.bam
#pigz -p ${CORES} ${SAM}

mkdir -p ${TEMPDIR}
samtools sort ${OPTIONS} ${SORTOPTS} ${PREFIX}.bam -o ${PREFIX}.sorted.bam
rm -rf ${TEMPDIR}
samtools index -b ${PREFIX}.sorted.bam ${PREFIX}.sorted.bai
