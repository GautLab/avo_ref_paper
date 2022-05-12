#!/bin/bash
#SBATCH -J augpamsm		# jobname
#SBATCH -o augpamsm.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e augpamsm.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 48
#SBATCH --mem-per-cpu=10416
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

MOUNTDIR=/data

singularity instance start --bind $(pwd):${MOUNTDIR} BRAKER_augustus.sif BRAKER
AUGUSTUS_CONFIG_PATH=${MOUNTDIR}/config
export AUGUSTUS_CONFIG_PATH=${MOUNTDIR}/config

PROTEINFILE=${MOUNTDIR}/Trinity.fasta.transdecoder.pep
BAM=${MOUNTDIR}/avocado.rnaseq.merged.bam
REF=${MOUNTDIR}/pamer.contigs.c21.consensus.consensus_pilon_pilon.masked.fasta
#SPECIES=arabidopsis
#SPECIES=cacao
SPECIES=avocado_gwen

singularity exec instance://BRAKER ls /data/
#singularity exec instance://BRAKER braker.pl --species=${SPECIES} --genome=${REF} --bam=${BAM} --prot_seq=${PROTEINFILE} --prg=gth --AUGUSTUS_BIN_PATH=/usr/local/bin --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} --AUGUSTUS_SCRIPTS_PATH=/opt/augustus-3.4.0/scripts --workingdir=${MOUNTDIR}
#singularity exec instance://BRAKER braker.pl --species=${SPECIES} --genome=${REF} --softmasking --bam=${BAM} --prot_seq=${PROTEINFILE} --prg=gth --AUGUSTUS_BIN_PATH=/usr/local/bin --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} --AUGUSTUS_SCRIPTS_PATH=/opt/augustus-3.4.0/scripts --workingdir=${MOUNTDIR}
singularity exec instance://BRAKER braker.pl --cores=${CORES} --species=${SPECIES} --genome=${REF} --bam=${BAM} --softmasking --AUGUSTUS_BIN_PATH=/usr/local/bin --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} --AUGUSTUS_SCRIPTS_PATH=/opt/augustus-3.4.0/scripts --workingdir=${MOUNTDIR}
#singularity exec instance://BRAKER braker.pl --cores=${CORES} --species=${SPECIES} --genome=${REF} --bam=${BAM} --softmasking --AUGUSTUS_BIN_PATH=/usr/local/bin --AUGUSTUS_CONFIG_PATH=${AUGUSTUS_CONFIG_PATH} --AUGUSTUS_SCRIPTS_PATH=/opt/augustus-3.4.0/scripts --workingdir=${MOUNTDIR} --gff3
singularity instance stop BRAKER

#perl /usr/bin/gmes_petap.pl --verbose --sequence=/data/genome.fa --ET=/data/genemark_hintsfile.gff --cores=48 --gc_donor 0.001 --soft_mask auto 1>/data/GeneMark-ET.stdout 2>/data/errors/GeneMark-ET.stderr
