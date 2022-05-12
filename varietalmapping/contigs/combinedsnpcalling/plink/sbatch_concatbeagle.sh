#!/bin/bash
#SBATCH -J concatbeagle
#SBATCH -o concatbeagle.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e concatbeagle.e%A.%a   # error file name
#SBATCH -a 1                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem=4000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}

#PREFIX=top15xsomes
PREFIX=allcontigs

head -n 1 $(ls avocado*tig*.PL | head -n 1) > avocado.haplo.noOG.recodeall.maf.recode.${PREFIX}.BEAGLE.PL
for i in $(ls avocado*tig*.PL)
   do grep -v marker $i >> avocado.haplo.noOG.recodeall.maf.recode.${PREFIX}.BEAGLE.PL
done

