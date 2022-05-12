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
REF=pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary.fasta

### BAM=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary_CarlsbadA_sorted.bam
#BAM=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
PREFIX=avocado
JAVACALL="java -Xmx120g -jar"
GATKLOC=$GATKDIR
#OUTPREFIX=$(basename ${REF} .fasta)

${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF} -T CombineGVCFs \
   -o ${PREFIX}.combined.g.vcf \
   --variant 001-01.g.vcf \
   --variant 069-02.g.vcf \
   --variant 263-C.g.vcf \
   --variant Anaheim.g.vcf \
   --variant Bacon.g.vcf \
   --variant Carlsbad.g.vcf \
   --variant CH-CR-25.g.vcf \
   --variant CH-G-07.g.vcf \
   --variant CH-G-10.g.vcf \
   --variant CH-G-11.g.vcf \
   --variant CH-GU-01.g.vcf \
   --variant Fairchild.g.vcf \
   --variant Fuerte_1.g.vcf \
   --variant Ganter.g.vcf \
   --variant Gwen.g.vcf \
   --variant Hass-2.g.vcf \
   --variant Hass-R.g.vcf \
   --variant Linda.g.vcf \
   --variant Lyon.g.vcf \
   --variant Mendez.g.vcf \
   --variant Nabal.g.vcf \
   --variant Nimlioh.g.vcf \
   --variant Ocotea_bothanthra.g.vcf \
   --variant PequenoCharly.g.vcf \
   --variant Persea_donnell_smithii.g.vcf \
   --variant Persea_hintonii.g.vcf \
   --variant Pinkerton.g.vcf \
   --variant Reed.g.vcf \
   --variant Simmonds.g.vcf \
   --variant Taft.g.vcf \
   --variant Thille.g.vcf \
   --variant TopaTopa.g.vcf \
   --variant VC26.g.vcf \
   --variant Velvick.g.vcf \
   --variant Waldin.g.vcf \
   --variant Zutano.g.vcf

${JAVACALL} ${GATKLOC}/GenomeAnalysisTK.jar -R ${REF} -T GenotypeGVCFs --variant ${PREFIX}.combined.g.vcf -o ${PREFIX}.haplo.vcf
