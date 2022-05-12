#!/bin/bash
#SBATCH -J gatkmergevcfs
#SBATCH -o gatkmergevcfs.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gatkmergevcfs.e%A.%a   # error file name
#SBATCH -a 1-1                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 1
#SBATCH --mem=120000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

#gatk 3.7
GATKDIR=/gpool/bin/gatk
PATH=/gpool/bin/jre1.8.0_221/bin:$PATH
export LD_LIBRARY_PATH=/gpool/bin/jre1.8.0_221/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/gpool/bin/jre1.8.0_221/
export JRE_HOME=/gpool/bin/jre1.8.0_221/
#picard tools
PICARDDIR=/gpool/bin/picardtools-2.24.1
###samtools 1.10
PATH=/gpool/bin/samtools-1.10/bin:$PATH
#vcf tools 02/20/2020
PATH=/gpool/bin/vcftools-vcftools-954e607/bin:/gpool/bin/vcftools-vcftools-954e607/bin/perl:$PATH
###bcftools 1.10
PATH=/gpool/bin/bcftools-1.10.2/bin:$PATH

#JOBFILE=bamfiles.txt
REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta

### BAM=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Carlsbad.merged_sorted.bam
#BAM=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
PREFIX=avocado
JAVACALL="java -Xmx120g -jar"
GATKLOC=$GATKDIR
#OUTPREFIX=$(basename ${REF} .fasta)

${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF} -T CombineGVCFs \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_001-01_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_069-02_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_263-C_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Anaheim.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Bacon.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Carlsbad.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_CH-CR-25_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_CH-G-07_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_CH-G-10_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_CH-G-11_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_CH-GU-01_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Fairchild.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Fuerte_1.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Ganter.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Guaslipe.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Gwen.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Hass-2_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Hass-R_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Linda.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Lyon.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Mendez_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Nabal.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Nimlioh.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Ocotea_bothanthra.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_PequenoCharly_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Persea_donnell_smithii.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Persea_hintonii.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Pinkerton.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Reed.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Simmonds.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Taft.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Thille.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_TopaTopa.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_VC26.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Velvick_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Waldin.merged_sorted.g.vcf \
   --variant pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_Zutano.merged_sorted.g.vcf \
   -o ${PREFIX}.combined.g.vcf \

${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF} -T GenotypeGVCFs --variant ${PREFIX}.combined.g.vcf -o ${PREFIX}.haplo.vcf
