#!/bin/bash
#SBATCH -J samtoolsuniq
#SBATCH -o samtoolsuniq.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsuniq.e%A.%a   # error file name
#SBATCH -a 37 ###6-36%6                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem-per-cpu=5000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.
###SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin  # email me when the job starts
###SBATCH --mail-type=end    # email me when the job finishes

PATH=/gpool/bin/samtools-1.11/bin:$PATH

JOBFILE=sortedbams.txt

### BAMFILE=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Fuerte_1A_sorted.bam
BAMFILE=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
LOCAL="./"
SORTOPTS="-m 3G -T ${LOCAL}/${SLURM_ARRAY_TASK_ID}"

### uniquely mapped
### _sorted.bam to _uniq.bam
samtools view -b -q 10 ${BAMFILE} > $(basename ${BAMFILE} _sorted.bam)_uniq.bam

### _uniq.bam
BAM=$(basename ${BAMFILE} _sorted.bam)_uniq.bam

#mkdir -p ${LOCAL}
mkdir -p ${LOCAL}/${SLURM_ARRAY_TASK_ID}
### _uniq.bam to _uniq_sorted.bam
samtools sort ${OPTIONS} ${SORTOPTS} ${BAM} -o $(basename ${BAM} .bam)_sorted.bam
rm -rf ${LOCAL}/${SLURM_ARRAY_TASK_ID}
### _uniq_sorted.bam to _uniq_sorted.bai
samtools index -b $(basename ${BAM} .bam)_sorted.bam $(basename ${BAM} .bam)_sorted.bai
### _uniq_sorted.bam to _uniq_sorted_stats.txt
samtools idxstats $(basename ${BAM} .bam)_sorted.bam > $(basename ${BAM} .bam)_sorted_stats.txt
