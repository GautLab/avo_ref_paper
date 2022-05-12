#!/bin/bash
#SBATCH -J gwenmum4              # jobname
#SBATCH -o gwenmum4.o%A.%a       # jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gwenmum4.e%A.%a       # error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-3                  # start and stop of the array start-end
###SBATCH -n 1                  # -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 4                   # -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1                  # queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=5000
###SBATCH -t 48:00:00           # run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin     # email me when the job starts
###SBATCH --mail-type=end       # email me when the job finishes

CORES=${SLURM_CPUS_PER_TASK}
###SLURM_ARRAY_TASK_ID

### SV calling using genome alignment using MUMmer V4.0

### module load MUMmer and environments
### MUMmer 4.0RC
PATH=/gpool/bin/mummer-4.0.0rc1/bin:$PATH


JOBFILE=jobfile.txt
QRY=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
REF=gwen_scaffolds_20kb.fasta

PREFIX=$(basename ${QRY} .fasta)_$(basename ${REF} .fasta)

### Alignment
#nucmer -p ${PREFIX} ${REF} ${QRY}

### filtering
#delta-filter -i 40 -u 10 -1 -l 500  ${PREFIX}.delta >  ${PREFIX}_filtered.delta

### Dot plotting
#mummerplot --filter --fat -p ${PREFIX} ${PREFIX}_filtered.delta --png
#mummerplot --filter --fat -p ${PREFIX} ${PREFIX}_filtered.delta --postscript
#-postscript -png

### Show SNPs
#show-snps -C -r ${PREFIX}_filtered.delta > ${PREFIX}.SNPs

### Show SVs using refer and query as reference. removed -l and -c option. due to error
show-diff -r ${PREFIX}_filtered.delta > ${PREFIX}_r.diff
show-diff -q ${PREFIX}_filtered.delta > ${PREFIX}_q.diff
#-c

### Show coordinates. the coordinates will help on finding the break points
show-coords  -r -c -l -L 500 -I 75 -o ${PREFIX}_filtered.delta > ${PREFIX}.coords
