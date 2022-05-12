#!/bin/bash
#SBATCH -J repeatmasker                # jobname
#SBATCH -o repeatmasker.o%A.%a         # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e repeatmasker.e%A.%a         # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1                    # start and stop of the array start-end
#SBATCH -A mcb190095p
###SBATCH --nodes=1
#SBATCH -N 1
#SBATCH -p RM           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=5000
#SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end         # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK

CORES=${SLURM_CPUS_ON_NODE}

SPECIES=Mesangiospermae
LIB=consensi.fa.classified
MOUNTDIR=$(pwd)
OUTDIR=${MOUNTDIR}/repeatmask
mkdir -p ${OUTDIR}
MYFASTA=pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta
MOUNTDIR=$(pwd)

singularity instance start --bind $(pwd):${MOUNTDIR} repeatmodeler.sif repeatmodeler

#RepeatMasker -pa ${SLURM_CPUS_PER_TASK} -s -species ${SPECIES} -a -poly -ace -excln -html -gff -dir ${OUTDIR} ./${MYFASTA}
singularity exec instance://repeatmodeler RepeatMasker -pa ${CORES} -s -lib consensi.fa.classified -a -poly -ace -excln -html -gff -dir ${OUTDIR} ${MYFASTA}

singularity instance stop repeatmodeler
