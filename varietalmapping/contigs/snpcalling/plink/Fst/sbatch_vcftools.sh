#!/bin/bash
#SBATCH -J vcfnplink
#SBATCH -o vcfnplink.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcfnplink.e%A.%a   # error file name
#SBATCH -a 1-1                  # 2304
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

POP1=lowland
POP2=mexican
POP3=guatemalan
POP4=cadomesticated
POP5=nongwengroup
POP6=nonantillean
POP7=nonguatemalan
POP8=nonmexican
POP9=typeA
POP10=typeB
POP11=outgroups
POP12=outgroupsnopsch
POP13=nooutgroupsclean.txt
POP14=nooutgroupscleanpsch.txt
POP15=perseaoutgroups

POPA=${POP3}
POPB=${POP4}
WINDOWSIZE=20000
OUTPREFIX=avo_${POPA}_v_${POPB}.$(($WINDOWSIZE/1000))kb
GZVCF=avocado.haplo.noBAD.recodeall.maf.recode.vcf.gz

vcftools --gzvcf ${GZVCF} --fst-window-size ${WINDOWSIZE} --weir-fst-pop ${POPA} --weir-fst-pop ${POPB} --out ${OUTPREFIX}
