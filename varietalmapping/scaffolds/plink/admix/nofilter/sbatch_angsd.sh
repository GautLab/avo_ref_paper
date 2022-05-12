#!/bin/bash
#SBATCH -J ngsadmix
#SBATCH -o ngsadmix.o%A.%a   # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e ngsadmix.e%A.%a   # error file name
#SBATCH -a 1-10                  # 2304
###SBATCH -n 1                # Total number of mpi tasks requested
###SBATCH --ntasks-per-node 1
#SBATCH -c 48
#SBATCH --mem-per-cpu=2500
###SBATCH --mem=30000
#SBATCH -p p1,gcluster     # queue (partition) -- normal, development, largemem, etc.

CORES=${SLURM_CPUS_PER_TASK}
#CORES=11

#SLURM_ARRAY_TASK_ID=$1

# angsd & NGSadmix
PATH=/gpool/bin/angsd/angsd:/gpool/bin/angsd/angsd/misc:$PATH

#BEAGLE.PL file
#PREFIX=gwen_avocado.scaffolds.haplo.noOG.recodeall.maf.recode.
PREFIX=gwen_avocado.scaffolds.haplo.amcfilter.noOG.recodeall.maf.recode.
PREFIX=${PREFIX}allcontigs

BGL=${PREFIX}.BEAGLE.PL

mkdir -p K${SLURM_ARRAY_TASK_ID}

for z in {1..10}
   do NGSadmix -likes ${BGL} -K ${SLURM_ARRAY_TASK_ID} -minMaf 0.05 -P ${CORES} -o K${SLURM_ARRAY_TASK_ID}/adx.${PREFIX}.K${SLURM_ARRAY_TASK_ID}_R${z}
done
