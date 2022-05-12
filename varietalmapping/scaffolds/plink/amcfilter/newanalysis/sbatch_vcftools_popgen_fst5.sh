#!/bin/bash
#SBATCH -J vcffststats
#SBATCH -o vcffststats.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcffststats.e%A.%a   # error file name
#SBATCH -a 10                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem=4000
#SBATCH -p p1     # queue (partition) -- normal, development, largemem, etc.

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}

###vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH
###plink 1.9
PATH=/gpool/amc/programs/plink_1.9:$PATH

#samples
#VCFFILE=gwen_avocado.scaffolds.haplo.amcfilter.noOG.recodeall.maf.recode.vcf.gz
VCFFILE=gwen_avocado.scaffolds.haplo.amcfilter.noOVLOG.recodeall.maf.recode.vcf.gz
WINDOWSIZE=20000
POP1=$(head -n $SLURM_ARRAY_TASK_ID fstcomparisons.txt | tail -n 1 | awk '{print $1}')
POP2=$(head -n $SLURM_ARRAY_TASK_ID fstcomparisons.txt | tail -n 1 | awk '{print $2}')
OUTPREFIX=$(basename ${VCFFILE} .vcf.gz)_${POP1}_v_${POP2}.$(($WINDOWSIZE/1000))kb

# calc Weir Fst
vcftools --gzvcf ${VCFFILE} --fst-window-size ${WINDOWSIZE} --weir-fst-pop ${POP1} --weir-fst-pop ${POP2} --out ${OUTPREFIX}
