#!/bin/bash
#SBATCH -J gwenmumm		# jobname
#SBATCH -o gwenmumm.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gwenmumm.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 4			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1,gcluster			# queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=20000
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

CORES=${SLURM_CPUS_PER_TASK}
###SLURM_ARRAY_TASK_ID

export PATH=/gpool/bin/quickmerge/MUMmer3.23:$PATH

REF=pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta
QRY=${REF}

### Alignment
#nucmer -p query2refer ${REF} ${QRY}

### filtering
delta-filter -i 40 -u 10 -1 -l 500  query2refer.delta > query2refer_filtered.delta

### Dot plotting​
mummerplot -postscript --filter --fat -p query2refer query2refer_filtered.delta

### Show SNPs​
show-snps -C -r query2refer_filtered.delta > query2refer_filtered.SNPs

## Show SVs using refer and query as reference
show-diff -r query2refer_filtered.delta > query2refer_r_filtered.diff
show-diff -q query2refer_filtered.delta > query2refer_q_filtered.diff

### Show coordinates. the coordinates will help on finding the break points
show-coords  -r -c -l -L 500 -I 75 -o query2refer_filtered.delta > query2refer_filtered.coords
