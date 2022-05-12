#!/bin/bash
#SBATCH -J picardtools
#SBATCH -o picardtools.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e picardtools.e%A.%a   # error file name
#SBATCH -a 1-1                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
###SBATCH --mem-per-cpu=1750
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

JAVACALL="java -Xmx19g -jar"
PICARDLOC=/networkshare/bin/picardtools-2.24.1
PATH=/gpool/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/gpool/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/gpool/bin/jre1.8.0_221/
export JRE_HOME=/gpool/bin/jre1.8.0_221/

for i in $(ls *.fasta)
do
    $JAVACALL $PICARDLOC/picard.jar CreateSequenceDictionary -R $i -O $(basename $i .fasta).dict
done
