#!/bin/bash
#SBATCH -J vcfstats
#SBATCH -o vcfstats.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcfstats.e%A.%a   # error file name
#SBATCH -a 1-1                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem=4000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

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
VCFFILE=avocado.haplo.noOG.recodeall.maf.recode.vcf.gz
OUTPREFIX=$(basename ${VCFFILE} .vcf.gz)

# calc pi
vcftools --gzvcf ${VCFFILE} --window-pi  10000 --out ${OUTPREFIX}_10kb

# calc tajimas-d
vcftools --gzvcf ${VCFFILE} --TajimaD  10000 --out ${OUTPREFIX}_10kb

# calc Fst
#vcftools --gzvcf ${VCFFILE} --weir-fst-pop ${POP1} --weir-fst-pop ${POP2} --out ${OUTPREFIX}_${POP1}_v_${POP2}_FST
