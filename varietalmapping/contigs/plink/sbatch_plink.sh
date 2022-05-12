#!/bin/bash
#SBATCH -J vcfnplink
#SBATCH -o vcfnplink.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e vcfnplink.e%A.%a   # error file name
#SBATCH -a 1-1                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 30
#SBATCH --mem=30000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}

#gatk 3.7
#GATKDIR=/gpool/bin/gatk
#PATH=/gpool/bin/jre1.8.0_221/bin:$PATH
#export LD_LIBRARY_PATH=/gpool/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
#export JAVA_HOME=/gpool/bin/jre1.8.0_221/
#export JRE_HOME=/gpool/bin/jre1.8.0_221/

#picard tools
#PICARDDIR=/gpool/bin/picardtools-2.24.1

###samtools 1.10
#PATH=/gpool/bin/samtools-1.10/bin:$PATH

###vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH

###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH

###plink 1.9
PATH=/gpool/amc/programs/plink_1.9:$PATH

OUTGROUPS=myoutgroups.txt
NOOUTGROUPS=nooutgroupsclean.txt
VCF=avocado.haplo.clean.vcf.gz

#vcftools --gzvcf ${VCF} --missing-indv

### vcftools version
#vcftools --gzvcf ${VCF} --remove ${OUTGROUPS} --out $(basename ${VCF} .clean.vcf.gz).filt --recode --recode-INFO-all
#vcftools --gzvcf ${VCF} --keep ${NOOUTGROUPS} --out $(basename ${VCF} .clean.vcf.gz).onlypsch --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).onlypsch.recode.vcf

#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).filt.recode.vcf

#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).filt.recode.vcf.gz --missing-indv

#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).filt.recode.vcf.gz --plink --out $(basename ${VCF} .clean.vcf.gz).filt.recode
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).filt.recode.vcf.gz --maf 0.05 --recode --out $(basename ${VCF} .clean.vcf.gz).filt.recode.maf

###Maf > 0.05 and filtered
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).filt.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode
#plink --file $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode.PCA

#only keep P. scheideanna outgroup
#vcftools --gzvcf ${VCF} --keep ${NOOUTGROUPS} --out $(basename ${VCF} .clean.vcf.gz).onlypsch --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).onlypsch.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).onlypsch.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .clean.vcf.gz).onlypsch.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).onlypsch.recodeall.maf.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).onlypsch.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .clean.vcf.gz).onlypsch.recodeall.maf.recode
#plink --file $(basename ${VCF} .clean.vcf.gz).onlypsch.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .clean.vcf.gz).onlypsch.recodeall.maf.recode.PCA

#no outgroups
#vcftools --gzvcf ${VCF} --keep ${NOOUTGROUPS} --out $(basename ${VCF} .clean.vcf.gz).noOG --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).noOG.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).noOG.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf.recode
#plink --file $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf.recode.PCA
vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf.recode.vcf.gz --BEAGLE-PL --out $(basename ${VCF} .clean.vcf.gz).noOG.recodeall.maf.recode.top15contigs \
   --chr tig00010057,tig00009953,tig00009963,tig00010449,tig00009968,tig00010588,tig00010178,tig00124635,tig00010327,tig00010512,tig00010694,tig00010525,tig00010151,tig00010260,tig00010069

#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).filt.recode.vcf.gz --maf 0.05 --recode --out $(basename ${VCF} .clean.vcf.gz).filt.recode.maf
#pigz -p ${CORES} $(basename ${VCF} .clean.vcf.gz).filt.recode.maf.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode
#plink --file $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .clean.vcf.gz).filt.recodeall.maf.recode.PCA
