#!/bin/bash
#SBATCH -J vcf2beagle
#SBATCH -o vcf2beagle.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcf2beagle.e%A.%a   # error file name
#SBATCH -a 1-958                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem=30000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}

###vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH

JOBFILE=chromosomes.txt
XSOME=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
VCF=avocado.haplo.clean.vcf.gz
#avocado.haplo.noBAD.*.recodeall.maf.recode.vcf.gz
POP=$1
OUTDIR=BEAGLEOUT.${POP}

echo ${POP}
mkdir -p ${OUTDIR}
vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).noBAD.${POP}.recodeall.maf.recode.vcf.gz --BEAGLE-PL --out ${OUTDIR}/$(basename ${VCF} .clean.vcf.gz).noBAD.${POP}.recodeall.maf.recode.${XSOME} \
   --chr ${XSOME}
