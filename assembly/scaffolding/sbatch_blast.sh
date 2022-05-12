#!/bin/bash
#SBATCH -J gwenblast		# jobname
#SBATCH -o gwenblast.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e gwenblast.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-1			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 32			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1,gcluster			# queue (partition) -- normal, development, largemem, etc.
#SBATCH --mem-per-cpu=2500
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

CORES=${SLURM_CPUS_PER_TASK}
###SLURM_ARRAY_TASK_ID

# import blast 2.2.31+
PATH=/gpool/bin/ncbi-blast-2.2.31+/bin:$PATH

#JOBFILE=jobfile.txt

# SNP Marker search
#MYDB=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta
#MYLABEL="Gwen_genome_1.8"
#MYDB=pamer.contigs.c21.consensus.consensus_pilon_pilon_new_1000_0.5157_0.5426to2.4158_0.2004_primary.fasta
#MYLABEL="Gwen_genome_2.1"
#MYDB=pamer.contigs.c21.consensus.consensus_pilon_pilon.fasta
#MYLABEL="Complete_Gwen_genome_2.1"
MYDB=pamer.contigs.consensus.consensus_pilon_pilon.fasta
MYLABEL="Complete_Gwen_genome_1.8"
QUERY=SHRSPa_sequence.fasta
#QUERY=vanessaMSL.fasta

# Retrotransposon search
#MYDB=Mytilus_californianus_ESTs_45k_sl.fasta
#MYLABEL="m_californianus_ests"
#QUERY=retroviridae.fasta
#MYDB=retroviridae.fasta
#MYLABEL="retroviridae"
#QUERY=Mytilus_californianus_ESTs_45k_sl.fasta
#QUERY=GHII01.1.fasta
#MYDB=GHII01.1.fasta


# Viral Search
#MYDB=viral.1.1.genomic.fasta
#MYLABEL="viral_db1"
#MYDB=viral.2.1.genomic.fasta
#MYLABEL="viral_db2"
#QUERY=viral.1.1.genomic.fasta
#QUERY=viral.2.1.genomic.fasta


makeblastdb -in ${MYDB} -input_type fasta -dbtype nucl -parse_seqids -out $(basename ${MYDB} .fasta) -title ${MYLABEL}
blastn -query ${QUERY} -db $(basename ${MYDB} .fasta)  -max_target_seqs 5 -outfmt 6 -evalue 1e-10 -num_threads ${CORES} > $(basename ${QUERY} .fasta)_$(basename ${MYDB} .fasta)_1e10_blastn.outfmt6
#blastn -query ${QUERY} -db $(basename ${MYDB} .fasta)  -max_target_seqs 5 -outfmt 6 -evalue 1 -num_threads ${CORES} > $(basename ${QUERY} .fasta)_$(basename ${MYDB} .fasta)_1e1_blastn.outfmt6
#tblastx -query ${QUERY} -db $(basename ${MYDB} .fasta)  -max_target_seqs 5 -outfmt 6 -evalue 1e-10 -num_threads ${CORES} > $(basename ${QUERY} .fasta)_$(basename ${MYDB} .fasta)_tblastxe1e10_blastn.outfmt6

