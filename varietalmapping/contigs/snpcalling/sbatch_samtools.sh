#!/bin/bash
#SBATCH -J samtoolsglab             # jobname
#SBATCH -o samtoolsglab.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsglab.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 22 	#24, 13          # start and stop of the array start-end
#SBATCH -c 16
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster           # queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH --mem-per-cpu=10000
###SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK

#module load samtools/1.11.0
PATH=/gpool/bin/bwa-0.7.17:/gpool/bin/samtools-1.11:$PATH

#CORES=$SLURM_CPUS_ON_NODE
CORES=$SLURM_CPUS_PER_TASK
LOCAL=./
i=${SLURM_ARRAY_TASK_ID}
#REF=pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta
REF=pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary.fasta

###gautlab samples
JOBFILE1="gautlabsamples.txt"

###hass study samples
#JOBFILE1="hasssamples.txt"

PREFIX=$(head -n $i ${JOBFILE1} | tail -n 1 | awk '{print $1}')
SAMA=$(basename ${REF} .fasta)_${PREFIX}A.sam.gz
SAMB=$(basename ${REF} .fasta)_${PREFIX}B.sam.gz
#SAM=$(basename ${REF} .fasta)_${PREFIX}.sam.gz
OPTIONS="--threads ${CORES}"
SORTOPTS="-m 3G -T ${LOCAL}/${SLURM_ARRAY_TASK_ID}"

###HASS
#samtools view ${OPTIONS} -b ${SAM} --reference ${REF} -o $(basename ${SAM} .sam.gz).bam
##pigz -p ${CORES} ${SAM}
#mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
#samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAM} .sam.gz).bam -o $(basename ${SAM} .sam.gz)_sorted.bam
#rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}
#samtools index -b $(basename ${SAM} .sam.gz)_sorted.bam $(basename ${SAM} .sam.gz)_sorted.bai

###GAUTLAB
samtools view ${OPTIONS} -b ${SAMA} --reference ${REF} -o $(basename ${SAMA} .sam.gz).bam
#pigz -p ${CORES} ${SAMA}
mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAMA} .sam.gz).bam -o $(basename ${SAMA} .sam.gz)_sorted.bam
rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools index -b $(basename ${SAMA} .sam.gz)_sorted.bam $(basename ${SAMA} .sam.gz)_sorted.bai

samtools view ${OPTIONS} -b ${SAMB} --reference ${REF} -o $(basename ${SAMB} .sam.gz).bam
#pigz -p ${CORES} ${SAMB}
mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAMB} .sam.gz).bam -o $(basename ${SAMB} .sam.gz)_sorted.bam
rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools index -b $(basename ${SAMB} .sam.gz)_sorted.bam $(basename ${SAMB} .sam.gz)_sorted.bai
