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

#VCF=gwen_avocado.scaffolds.haplo.amcfilter.noOVLOG.recodeall.maf.recode.vcf.gz
VCF=gwen_avocado.scaffolds.haplo.amcfilter.noOVL.onlypsch.recodeall.maf.recode.vcf.gz

head -n 1 $(ls BEAGLEOUT/*.PL | head -n 1) > $(basename ${VCF} .vcf.gz).${PREFIX}.BEAGLE.PL

for i in $(ls BEAGLEOUT/*.PL)
   do grep -v marker $i >> $(basename ${VCF} .vcf.gz).${PREFIX}.BEAGLE.PL
done

