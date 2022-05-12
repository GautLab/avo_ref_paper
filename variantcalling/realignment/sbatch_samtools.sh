#!/bin/bash
#SBATCH -J samtoolsmm2			# jobname
#SBATCH -o samtoolsmm2.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsmm2.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 6				# start and stop of the array start-end
#SBATCH -c 16
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster			# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH --mem-per-cpu=5000
###SBATCH -t 48:00:00			# run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin		# email me when the job starts
#SBATCH --mail-type=end			# email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

#module load samtools/1.11.0
PATH=/gpool/bin/samtools-1.11:$PATH

#CORES=$SLURM_CPUS_ON_NODE
CORES=$SLURM_CPUS_PER_TASK
LOCAL=./
i=${SLURM_ARRAY_TASK_ID}
#REF=pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta
#REF=pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary.fasta
REF=gwen_scaffolds_20kb.fasta

JOBFILE=jobfile1.txt
#JOBFILE=jobfile2.txt

SAM=$(head -n ${i} ${JOBFILE} | tail -n 1)
OPTIONS="--threads ${CORES}"
SORTOPTS="-m 3G -T ${LOCAL}/${SLURM_ARRAY_TASK_ID}"

samtools view ${OPTIONS} -b ${SAM} --reference ${REF} -o $(basename ${SAM} .sam).bam
pigz -p ${CORES} ${SAM}
mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAM} .sam).bam -o $(basename ${SAM} .sam)_sorted.bam
rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools index -b $(basename ${SAM} .sam)_sorted.bam $(basename ${SAM} .sam)_sorted.bai
