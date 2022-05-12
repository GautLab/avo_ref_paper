#!/bin/bash -l
#SBATCH --job-name=SweeD_avo
#SBATCH -p gcluster
#SBATCH -n 2
#SBATCH -N 1
#SBATCH --mem=200G
#SBATCH --mail-type=all

# Make sure we start in the right place
cd /gpool/swyant/projects/avo_ref_paper/SweeD_analysis

# Creating a file with the population names 
printf "guatemalan\nlowland\nmexican\nwild\ndomesticated" > pops.list

# Running all pops in a loop
# Note that each pop requires its own dir because SweeD outputs a file per chromosome (a lot of files)
for i in $(cat pops.list)
do 
    mkdir -p ${i}
    cd ${i}
    /gpool/amc/programs/sweed_v4.0.0/SweeD-P -name ${i}.10k -input /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/vcfs_uncompressed/Pamericana_gwen.filtered.SNPs.${i}.vcf -reports -threads 2 -grid 10000
    cd ../ 
done

