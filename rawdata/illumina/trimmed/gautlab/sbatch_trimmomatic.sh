#!/bin/bash
#SBATCH -J trimgl		# jobname
#SBATCH -o trimgl.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e trimgl.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 43-50		# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=16
#SBATCH -c 16
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
###SBATCH --mem-per-cpu=4000
###SBATCH -t 48:00:00             # run time (dd:hh:mm:ss) - 1.5 hours
#SBATCH --mail-user=solarese@uci.edu
#SBATCH --mail-type=begin       # email me when the job starts
#SBATCH --mail-type=end		# email me when the job finishes
#SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

#module load java
###java 1.8.221
PATH=/networkshare/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/networkshare/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/networkshare/bin/jre1.8.0_221/
export JRE_HOME=/networkshare/bin/jre1.8.0_221/
SLURM_CPUS_ON_NODE=16
SLURM_ARRAY_TASK_ID=45
#PATH=/home/solares/bin/Trimmomatic-0.39:$PATH
PATH=/networkshare/bin/Trimmomatic-0.39:$PATH

JOBFILE="jobfile.txt"
i=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
#i=$1
echo $i

#TRIMMOMATIC="/home/solares/bin/Trimmomatic-0.39/"
TRIMMOMATIC="/networkshare/bin/Trimmomatic-0.39/"
TRIM="java -jar ${TRIMMOMATIC}trimmomatic-0.39.jar"
OPTIONS1="PE -threads ${SLURM_CPUS_ON_NODE} -phred33 -trimlog ./${OUTFILE}.log"
OPTIONS2="ILLUMINACLIP:${TRIMMOMATIC}adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:60"

INPUT="./${i}-READ1-Sequences.txt.gz ./${i}-READ2-Sequences.txt.gz"
OUTPUT="./${i}_1_paired_trimm.fastq ./${i}_1_unpaired_trimm.fastq ./${i}_2_paired_trimm.fastq ./${i}_2_unpaired_trimm.fastq"

${TRIM} ${OPTIONS1} ${INPUT} ${OUTPUT} ${OPTIONS2}

pigz -p ${SLURM_CPUS_ON_NODE} ${i}_1_paired_trimm.fastq
pigz -p ${SLURM_CPUS_ON_NODE} ${i}_1_unpaired_trimm.fastq
pigz -p ${SLURM_CPUS_ON_NODE} ${i}_2_paired_trimm.fastq
pigz -p ${SLURM_CPUS_ON_NODE} ${i}_2_unpaired_trimm.fastq
