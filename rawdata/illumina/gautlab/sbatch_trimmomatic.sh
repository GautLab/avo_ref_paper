#!/bin/bash
#SBATCH -J hapsoloanf           # jobname
#SBATCH -o hapsoloanf.o%A.%a    # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e hapsoloanf.e%A.%a    # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1                  # start and stop of the array start-end
###SBATCH -n 1                  # -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 10                   # -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1,gcluster                  # queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=12000
###SBATCH -t 48:00:00           # run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin     # email me when the job starts
###SBATCH --mail-type=end       # email me when the job finishes

###java 1.8.221
PATH=/networkshare/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/networkshare/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/networkshare/bin/jre1.8.0_221/
export JRE_HOME=/networkshare/bin/jre1.8.0_221/

PATH=/networkshare/bin/Trimmomatic-0.39:$PATH
ADAPTERFILE=/networkshare/bin/preprocess.seq-1.0/TruSeq-PE.fa

# This should contain prefix for READS
JOBFILE="jobfile.txt"
i=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)

TRIMMOMATIC="/networkshare/bin/Trimmomatic-0.39/"
TRIM="java -jar ${TRIMMOMATIC}trimmomatic-0.39.jar"
OPTIONS1="PE -threads ${SLURM_CPUS_PER_TASK} -phred33 -trimlog ./${OUTFILE}.log"
OPTIONS2="ILLUMINACLIP:${ADAPTERFILE}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:60"

# Take prefix of reads and distinguish between read1 and read2. Edit input bu leave output alone.
INPUT="./${i}-READ1-Sequences.txt.gz ./${i}-READ2-Sequences.txt.gz"
OUTPUT="./${i}_1_paired_trimm.fastq ./${i}_1_unpaired_trimm.fastq ./${i}_2_paired_trimm.fastq ./${i}_2_unpaired_trimm.fastq"

${TRIM} ${OPTIONS1} ${INPUT} ${OUTPUT} ${OPTIONS2}

pigz -p ${SLURM_CPUS_PER_TASK} ${i}_1_paired_trimm.fastq
pigz -p ${SLURM_CPUS_PER_TASK} ${i}_1_unpaired_trimm.fastq
pigz -p ${SLURM_CPUS_PER_TASK} ${i}_2_paired_trimm.fastq
pigz -p ${SLURM_CPUS_PER_TASK} ${i}_2_unpaired_trimm.fastq

