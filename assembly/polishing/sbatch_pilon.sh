#!/bin/bash
#SBATCH -J pilon             # jobname
#SBATCH -o pilon.o%A.%a      # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e pilon.e%A.%a      # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 2          # start and stop of the array start-end
#SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p LM           # queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
#SBATCH --mem=1000GB
#SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end # email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

module load java samtools/1.9
PILON=/home/solares/bin/pilon/pilon-1.23.jar

JOBFILE="references.txt"

SEED=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=${SEED}

PREFIX=gwenPE
SAM=${PREFIX}_$(basename ${REF} .fasta).sam
BAM=$(basename ${SAM} .sam)_sorted.bam
OPTIONS="--vcf --tracks"

#do an if statement
samtools faidx ${REF}
java -Xmx1000G -jar ${PILON} ${OPTIONS} --genome ${REF} --frags ${BAM} --output ./$(basename ${REF} .fasta)_pilon
