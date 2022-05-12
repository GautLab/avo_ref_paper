#!/bin/bash
#SBATCH -J samtoolspnas             # jobname
#SBATCH -o samtoolspnas.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolspnas.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-13          # start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -c 16
#SBATCH -p p1,gcluster            # queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH --mem-per-cpu=7500
###SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

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

###hass study samples
JOBFILE1="hasssamples.txt"

PREFIX=$(head -n $i ${JOBFILE1} | tail -n 1 | awk '{print $1}')
SAM=$(basename ${REF} .fasta)_${PREFIX}.sam.gz
OPTIONS="--threads ${CORES}"
LOCAL="./"
TEMPDIR="${LOCAL}/${REF}_PNAS_${SLURM_ARRAY_TASK_ID}"
SORTOPTS="-m 3G -T ${TEMPDIR}"

###HASS
samtools view ${OPTIONS} -b ${SAM} --reference ${REF} -o $(basename ${SAM} .sam.gz).bam
pigz -p ${CORES} ${SAM}
mkdir -p ${TEMPDIR}
samtools sort ${OPTIONS} ${SORTOPTS} $(basename ${SAM} .sam.gz).bam -o $(basename ${SAM} .sam.gz)_sorted.bam
rm -rf ${TEMPDIR}
samtools index -b $(basename ${SAM} .sam.gz)_sorted.bam $(basename ${SAM} .sam.gz)_sorted.bai
