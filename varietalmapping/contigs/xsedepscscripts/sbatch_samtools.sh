#!/bin/bash
#SBATCH -J samtoolsgl             # jobname
#SBATCH -o samtoolsgl.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsgl.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-13          # start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p RM           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

module load samtools/1.9

i=${SLURM_ARRAY_TASK_ID}
REF=$1

###gautlab samples
#JOBFILE1="gautlabsamples.txt"

###hass study samples
JOBFILE1="hasssamples.txt"

PREFIX=$(head -n $i ${JOBFILE1} | tail -n 1 | awk '{print $1}')
#SAMA=$(basename ${REF} .fasta)_${PREFIX}A.sam
#SAMB=$(basename ${REF} .fasta)_${PREFIX}B.sam
SAM=$(basename ${REF} .fasta)_${PREFIX}.sam
OPTIONS="--threads ${SLURM_CPUS_ON_NODE}"
SORTOPTS="-m 3G -T ${LOCAL}/${REF}_${SLURM_ARRAY_TASK_ID}"

###HASS
samtools view ${OPTIONS} -b ${SAM} --reference ${REF} -o $(basename ${SAM} .sam).bam
pigz -p ${SLURM_ARRAY_TASK_ID} ${SAM}
mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAM} .sam).bam -o $(basename ${SAM} .sam)_sorted.bam
rm -rf ${LOCAL}/${REF}_${SLURM_ARRAY_TASK_ID}
samtools index -b $(basename ${SAM} .sam)_sorted.bam $(basename ${SAM} .sam)_sorted.bai

###GAUTLAB
#samtools view ${OPTIONS} -b ${SAMA} --reference ${REF} -o $(basename ${SAMA} .sam).bam
#pigz -p ${SLURM_ARRAY_TASK_ID} ${SAMA}
#mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
#samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAMA} .sam).bam -o $(basename ${SAMA} .sam)_sorted.bam
#rm -rf ${LOCAL}/${REF}_${SLURM_ARRAY_TASK_ID}
#samtools index -b $(basename ${SAMA} .sam)_sorted.bam $(basename ${SAMA} .sam)_sorted.bai

#samtools view ${OPTIONS} -b ${SAMB} --reference ${REF} -o $(basename ${SAMB} .sam).bam
#pigz -p ${SLURM_ARRAY_TASK_ID} ${SAMB}
#mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
#samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAMB} .sam).bam -o $(basename ${SAMB} .sam)_sorted.bam
#rm -rf ${LOCAL}/${REF}_${SLURM_ARRAY_TASK_ID}
#samtools index -b $(basename ${SAMB} .sam)_sorted.bam $(basename ${SAMB} .sam)_sorted.bai

