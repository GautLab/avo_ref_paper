#!/bin/bash
#SBATCH -J vcfnplinkpca3
#SBATCH -o vcfnplinkpca3.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcfnplinkpca3.e%A.%a   # error file name
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
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH
###plink 1.9
PATH=/gpool/amc/programs/plink_1.9:$PATH

OUTGROUPS=myoutgroups.txt
NOOUTGROUPS=nooutgroupsclean.txt
NOOUTGROUPSPSCH=nooutgroupscleanpsch.txt
VCF=avocado.haplo.clean.amcfilter.vcf.gz
NOBADSAMPLES=nobadsamples.txt

#vcftools --gzvcf ${VCF} --missing-indv

### vcftools version 1.10

###Start pipeline
#vcftools --gzvcf ${VCF} --remove ${OUTGROUPS} --out $(basename ${VCF} .vcf.gz).filt --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).filt.recode.vcf

###Maf > 0.05 and filtered
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).filt.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).filt.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).filt.recodeall.maf.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).filt.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .vcf.gz).filt.recodeall.maf.recode
#plink --file $(basename ${VCF} .vcf.gz).filt.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .vcf.gz).filt.recodeall.maf.recode.PCA

#only keep P. scheideanna outgroup
#vcftools --gzvcf ${VCF} --keep ${NOOUTGROUPS} --out $(basename ${VCF} .vcf.gz).onlypsch --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).onlypsch.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).onlypsch.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).onlypsch.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).onlypsch.recodeall.maf.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).onlypsch.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .vcf.gz).onlypsch.recodeall.maf.recode
#plink --file $(basename ${VCF} .vcf.gz).onlypsch.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .vcf.gz).onlypsch.recodeall.maf.recode.PCA

#Primary for PCA analysis
#no outgroups
vcftools --gzvcf ${VCF} --keep ${NOOUTGROUPS} --out $(basename ${VCF} .vcf.gz).noOG --recode --recode-INFO-all
pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noOG.recode.vcf
vcftools --gzvcf $(basename ${VCF} .vcf.gz).noOG.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf
pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.vcf
vcftools --gzvcf $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode
plink --file $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.PCA
