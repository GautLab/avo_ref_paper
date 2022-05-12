#!/bin/bash
#SBATCH -J samtoolsgl             # jobname
#SBATCH -o samtoolsgl.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsgl.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-24          # start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -c 16
#SBATCH -p p1,gcluster           # queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH --mem-per-cpu=8000
###SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin       # email me when the job starts
###SBATCH --mail-type=end # email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

#module load samtools/1.11
PATH=/gpool/bin/samtools-1.11/bin:$PATH
#CORES=$SLURM_CPUS_ON_NODE
CORES=$SLURM_CPUS_PER_TASK

i=${SLURM_ARRAY_TASK_ID}
REF=gwen_scaffolds.fasta

###gautlab samples
JOBFILE1="gautlabsamples.txt"

PREFIX=$(head -n $i ${JOBFILE1} | tail -n 1 | awk '{print $1}')
SAMA=$(basename ${REF} .fasta)_${PREFIX}A.sam.gz
SAMB=$(basename ${REF} .fasta)_${PREFIX}B.sam.gz
OPTIONS="--threads ${CORES}"
LOCAL="./"
TEMPDIR="${LOCAL}/${REF}_GLAB_${SLURM_ARRAY_TASK_ID}"
SORTOPTS="-m 3G -T ${TEMPDIR}"

###GAUTLAB
samtools view ${OPTIONS} -b ${SAMA} --reference ${REF} -o $(basename ${SAMA} .sam.gz).bam
#pigz -p ${CORES} ${SAMA}
mkdir -p ${TEMPDIR}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAMA} .sam.gz).bam -o $(basename ${SAMA} .sam.gz)_sorted.bam
rm -rf ${TEMPDIR}
samtools index -b $(basename ${SAMA} .sam.gz)_sorted.bam $(basename ${SAMA} .sam.gz)_sorted.bai

samtools view ${OPTIONS} -b ${SAMB} --reference ${REF} -o $(basename ${SAMB} .sam.gz).bam
#pigz -p ${CORES} ${SAMB}
mkdir -p ${TEMPDIR}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAMB} .sam.gz).bam -o $(basename ${SAMB} .sam.gz)_sorted.bam
rm -rf ${TEMPDIR}
samtools index -b $(basename ${SAMB} .sam.gz)_sorted.bam $(basename ${SAMB} .sam.gz)_sorted.bai
