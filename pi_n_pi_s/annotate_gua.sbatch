#!/bin/bash -l
#SBATCH --job-name=snpeffgua
#SBATCH -p gcluster
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem=12G

PATH=/gpool/bin/jdk-11.0.16/bin:$PATH
export LD_LIBRARY_PATH=/gpool/bin/jdk-11.0.16/lib:$LD_LIBRARY_PATH
export JAVA_HOME=/gpool/bin/jdk-11.0.16/
export JRE_HOME=/gpool/bin/jdk-11.0.16/

cd /gpool/swyant/software/snpEff

java -jar ./snpEff.jar gwen2 /gpool/swyant/projects/avo_ref_paper/pi_n_pi_s/Pamericana_gwen.filtered.SNPs.guatemalan.vcf > guatemalan.ann.vcf



