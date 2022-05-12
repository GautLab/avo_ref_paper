#!/bin/bash
#SBATCH -J Ucallvariantsvcf
#SBATCH -o callvariantsvcf.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e callvariantsvcf.e%A.%a   # error file name
#SBATCH -a 1-1			# 2
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem-per-cpu=4000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

###samtools 1.11
PATH=/gpool/bin/samtools-1.11/bin:$PATH
#vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH

#JOBFILE=chromosomes.txt
#REF=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=gwen_scaffolds.fasta
OUTPREFIX=$1_$(basename ${REF} .fasta)
#BAMFILES=bamuniqsortedfiles_${OUTPREFIX}.txt
### ls *_uniq_sorted.bam
BAMFILES=bamuniqsortedfiles.txt

# use bcftools mpileup instead of samtools mpileup
samtools mpileup -u -C50 -f ${REF} -b ${BAMFILES} > ${OUTPREFIX}_uniqbams.bcf

# for haploid sample
###bcftools call -mv --ploidy 1 ${OUTPREFIX}_uniqbams.bcf > ${OUTPREFIX}.raw.vcf
# for diploid sample
bcftools call -mv ${OUTPREFIX}_uniqbams.bcf > ${OUTPREFIX}.raw.vcf

## filter lowquality reads of QV<20 and coverage>32. This should be 4x your avg coverage
bcftools filter -s LowQual -e '%QUAL<20 || DP>32' ${OUTPREFIX}.raw.vcf  > ${OUTPREFIX}.flt.vcf
#bcftools filter -s LowQual -e '%QUAL<20 || DP>182' ${OUTPREFIX}.raw.vcf  > ${OUTPREFIX}.flt.vcf
vcftools --vcf ${OUTPREFIX}.flt.vcf --recode-INFO-all --keep-only-indels --out ${OUTPREFIX}_indel --recode
