#!/bin/bash
#SBATCH -J vcftoolskeeppops
#SBATCH -o vcftoolskeeppops.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcftoolskeeppops.e%A.%a   # error file name
#SBATCH -a 1-10                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem=30000
#SBATCH -p p1     # queue (partition) -- normal, development, largemem, etc.

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}

###vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH

VCF=gwen_avocado.scaffolds.haplo.amcfilter.vcf.gz

# POPULATIONS
POP=$(head -n $SLURM_ARRAY_TASK_ID pops.txt | tail -n 1 | awk '{print $1}')
PREFIX=$(head -n $SLURM_ARRAY_TASK_ID pops.txt | tail -n 1 | awk '{print $2}')

# EXTRACT POP AND RECODE WITH MAF > 0.05
vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${POP} --out $(basename ${VCF} .vcf.gz).noBAD.${PREFIX} --recode --recode-INFO-all
pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.${PREFIX}.recode.vcf
vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.${PREFIX}.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.${PREFIX}.recodeall.maf
pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.${PREFIX}.recodeall.maf.recode.vcf
