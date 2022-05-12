#!/bin/bash
#SBATCH -J samtoolsidx
#SBATCH -o samtoolsidx.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e samtoolsidx.e%A.%a   # error file name
#SBATCH -a 1-63%10                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
###SBATCH --mem-per-cpu=1750
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.
###SBATCH -t 48:00:00        # run time (hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin  # email me when the job starts
###SBATCH --mail-type=end    # email me when the job finishes

PATH=/gpool/bin/samtools-1.10/bin:$PATH

JOBFILE=sortedbams.txt

BAMFILE=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)

samtools index -b ${BAMFILE} $(basename ${BAMFILE} .bam).bai
samtools idxstats ${BAMFILE} > $(basename ${BAMFILE} .bam)_stats.txt
