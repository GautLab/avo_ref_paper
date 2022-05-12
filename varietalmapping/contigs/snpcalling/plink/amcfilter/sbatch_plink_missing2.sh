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
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH
###plink 1.9
PATH=/gpool/amc/programs/plink_1.9:$PATH

OUTGROUPS=myoutgroups.txt
NOOUTGROUPS=nooutgroupsclean.txt
NOOUTGROUPSPSCH=nooutgroupscleanpsch.txt
VCF=avocado.haplo.clean.amcfilter.vcf.gz
NOBADSAMPLES=nobadsamples.txt

vcftools --gzvcf ${VCF} --missing-indv

### vcftools version

###Old pipeline
#vcftools --gzvcf ${VCF} --remove ${OUTGROUPS} --out $(basename ${VCF} .vcf.gz).filt --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).filt.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).filt.recode.vcf.gz --missing-indv
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).filt.recode.vcf.gz --plink --out $(basename ${VCF} .vcf.gz).filt.recode
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).filt.recode.vcf.gz --maf 0.05 --recode --out $(basename ${VCF} .vcf.gz).filt.recode.maf

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
#vcftools --gzvcf ${VCF} --keep ${NOOUTGROUPS} --out $(basename ${VCF} .vcf.gz).noOG --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noOG.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noOG.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode
#plink --file $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.PCA

#Primary for Fst Analysis
#remove bad samples
#vcftools --gzvcf ${VCF} --keep ${NOBADSAMPLES} --out $(basename ${VCF} .vcf.gz).noBAD --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf
#Plink output
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.vcf.gz --plink --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode
#plink --file $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.PCA
# Seperate out groups
POP1=mexican
POP2=guatemalan
POP3=antilian
OGS=outgroups
POGS=perseaoutgroups
FTA=typeA
FTB=typeB
#Mexican Pop
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${POP1} --out $(basename ${VCF} .vcf.gz).noBAD.MEX --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.MEX.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.MEX.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.MEX.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.MEX.recodeall.maf.recode.vcf
#Guatemalan Pop
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${POP2} --out $(basename ${VCF} .vcf.gz).noBAD.GUA --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.GUA.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.GUA.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.GUA.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.GUA.recodeall.maf.recode.vcf
#Antilion Pop
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${POP3} --out $(basename ${VCF} .vcf.gz).noBAD.ANT --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.ANT.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.ANT.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.ANT.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.ANT.recodeall.maf.recode.vcf
#Persea Outgroups only
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${POGS} --out $(basename ${VCF} .vcf.gz).noBAD.POGS --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.POGS.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.POGS.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.POGS.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.POGS.recodeall.maf.recode.vcf
#All Outgroups only
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${OGS} --out $(basename ${VCF} .vcf.gz).noBAD.OGS --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.OGS.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.OGS.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.OGS.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.OGS.recodeall.maf.recode.vcf
#All Clean Outgroups only
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${OGS} --out $(basename ${VCF} .vcf.gz).noBAD.COGS --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.COGS.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.COGS.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.COGS.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.COGS.recodeall.maf.recode.vcf
#All Flower TypeA
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${FTA} --out $(basename ${VCF} .vcf.gz).noBAD.FTA --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.FTA.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.FTA.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.FTA.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.FTA.recodeall.maf.recode.vcf
#All Flower TypeA
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.recodeall.maf.recode.vcf.gz --keep ${FTA} --out $(basename ${VCF} .vcf.gz).noBAD.FTB --recode --recode-INFO-all
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.FTB.recode.vcf
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noBAD.FTB.recode.vcf.gz --maf 0.05 --recode --recode-INFO-all --out $(basename ${VCF} .vcf.gz).noBAD.FTB.recodeall.maf
#pigz -p ${CORES} $(basename ${VCF} .vcf.gz).noBAD.FTB.recodeall.maf.recode.vcf

###Make Beagle file based on top 15 contigs
#vcftools --gzvcf $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.vcf.gz --BEAGLE-PL --out $(basename ${VCF} .vcf.gz).noOG.recodeall.maf.recode.top15contigs \
#   --chr tig00010057,tig00009953,tig00009963,tig00010449,tig00009968,tig00010588,tig00010178,tig00124635,tig00010327,tig00010512,tig00010694,tig00010525,tig00010151,tig00010260,tig00010069

###Make PCA but put another sbatch file
#plink --file $(basename ${VCF} .vcf.gz).filt.recodeall.maf.recode --memory 30000 --threads ${CORES} --pca --out $(basename ${VCF} .vcf.gz).filt.recodeall.maf.recode.PCA
