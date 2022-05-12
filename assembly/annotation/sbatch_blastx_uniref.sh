#!/bin/bash
#SBATCH -J blastxuniref		# jobname
#SBATCH -o blastxuniref.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e blastxuniref.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 32
#SBATCH --mem-per-cpu=2500
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end		# email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE
#  $SLURM_CPUS_PER_TASK

CORES=${SLURM_CPUS_PER_TASK}

PATH=/gpool/bin/ncbi-blast-2.2.31+/bin:$PATH

#QRY=avo_c20asm_floweringtype_fst.hits.fasta
#QRY=avo_typeA_v_typeB.gtpt75.10k.windowed.weir.sorted.outfmt6.c21.gene.hits.sorted.fasta
#QRY=avo_typeA_v_typeB.gtpt75.10k.windowed.weir.sorted.c20.CDS.hits.sorted.CDS.hass.fasta
#QRY=avo_typeA_v_typeB.top1pct.10k.windowed.weir.sorted.c20.gene.hits.sorted.gene.hass.fasta
QRY=pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.fasta
#QRY=pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.mRNA.fasta

#UNIREF90
MYDB=/gpool/databases/uniref90_2021_02/uniref90
#OUTFILE=$(basename ${QRY} .fasta)_uniref90_blastx.outfmt6
OUTFILE=$(basename ${QRY} .fasta)_uniref90.blastx.outfmt6

blastx -query ${QRY}  \
    -db ${MYDB} -max_target_seqs 1 \
    -outfmt 6 -evalue 1e-5 -num_threads ${CORES} > ${OUTFILE}
