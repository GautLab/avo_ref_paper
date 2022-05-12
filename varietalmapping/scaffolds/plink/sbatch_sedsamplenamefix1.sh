#!/bin/bash
#SBATCH -J sedfixnames
#SBATCH -o sedfixnames.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e sedfixnames.e%A.%a   # error file name
#SBATCH -a 1-1                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 16
#SBATCH --mem=4000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}

VCFFILE=avocado.haplo.vcf

#zcat ${VCFFILE} | sed 's/pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary_//g' | sed 's/.merged_sorted//g' | sed 's/_sorted//g' > avocado.haplo.clean.vcf

pigz -p ${CORES} avocado.haplo.clean.vcf
