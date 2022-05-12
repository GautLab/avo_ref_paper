#!/bin/bash
#SBATCH -J blastpswissprot		# jobname
#SBATCH -o blastpswissprot.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e blastpswissprot.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-2810			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 8
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
#  $SLURM_ARRAY_TASK_ID

CORES=${SLURM_CPUS_PER_TASK}

PATH=/gpool/bin/ncbi-blast-2.2.31+/bin:$PATH

JOBFILE=peptidejobfile.txt

#QRY=avo_c20asm_floweringtype_fst.hits.fasta
#QRY=avo_typeA_v_typeB.gtpt75.10k.windowed.weir.sorted.outfmt6.c21.gene.hits.sorted.fasta
#QRY=avo_typeA_v_typeB.gtpt75.10k.windowed.weir.sorted.c20.CDS.hits.sorted.CDS.hass.fasta
#QRY=avo_typeA_v_typeB.top1pct.10k.windowed.weir.sorted.c20.gene.hits.sorted.gene.hass.fasta
#New queries
#QRY=pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.pep
#QRY=gwen_braker_rnaseq_hapsolo_annotation.genes.wotesnexons.avo_typeA_v_typeB.top1pct.20k.windowed.weir.pep
#QRY=gwen_braker_rnaseq_hapsolo_annotation.genes.avo_typeA_v_typeB.top1pct.20k.windowed.weir.pep
#QRY=pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.genes.fasta
#QRY=pamer.contigs.c21.consensus.consensus_pilon_pilon.gene.annotation.mRNA.fasta
QRY=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)


#SWISSPROT_UNIPROT
MYDB=/gpool/databases/swissprot_2021_02/uniprot_sprot
#OUTFILE=./fstpeaksearch/blastoutput/$(basename ${QRY} .pep)_swissprot_blastp.outfmt6
OUTFILE=blastp_swissprot/$(basename ${QRY} .pep)_swissprot_uniprot.blastp.outfmt6


blastp -query ${QRY}  \
    -db ${MYDB} -max_target_seqs 1 \
    -outfmt 6 -evalue 1e-5 -num_threads ${CORES} > ${OUTFILE}
