#!/bin/bash
#SBATCH -J augpam		# jobname
#SBATCH -o augpam.o%A.%a		# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e augpam.e%A.%a		# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1			# start and stop of the array start-end
###SBATCH --nodes=1
###SBATCH --ntasks-per-node=1
#SBATCH -p p1,gcluster		# queue (partition) -- compute, shared, large-shared, debug (30mins)
#SBATCH -c 4
#SBATCH --mem-per-cpu=8000
###SBATCH -t 72:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end		# email me when the job finishes
###SBATCH --export=ALL

# Set the number of threads per task(Default=1)
#export OMP_NUM_THREADS=1
#export MV2_SHOW_CPU_BINDING=1
#  $SLURM_CPUS_ON_NODE

#source ~/.conda3rc
#conda activate augustus20201116
### Augustus 3.4.1 BRAKER2
MOUNTDIR=/data
CFGFILE=extrinsic.MPE.cfg
#CFGFILE=extrinsic.ME.cfg

singularity instance start --bind ./:${MOUNTDIR} BRAKER_augustus.sif BRAKER
AUGUSTUS_CONFIG_PATH=${MOUNTDIR}/config
export AUGUSTUS_CONFIG_PATH=${MOUNTDIR}/config
#singularity exec instance://BRAKER cp -rf /opt/augustus-3.4.0/config /data/

SPECIES=arabidopsis
PROTEINFILE=Trinity.fasta.transdecoder.pep
CDSFILE=Trinity.fasta.transdecoder.cds
#REF=pamer.contigs.consensus.consensus_pilon_pilon.fasta
REF=pamer.contigs.consensus.consensus_pilon_pilon_new_1000_0.2593_0.4755to2.9226_0.2012_primary.fasta
INPUTFILE=$(basename $REF .fasta)_$(basename $CDSFILE .cds).sorted.psl
PREFIX=$(basename ${INPUTFILE} .sorted.psl)

#sort first
head -n 5 $(basename $REF .fasta)_$(basename $CDSFILE .cds).psl > ${INPUTFILE}
tail -n +6 $(basename $REF .fasta)_$(basename $CDSFILE .cds).psl | sort -n -k 16,16 | sort -s -k 14,14 >> ${INPUTFILE}
singularity exec instance://BRAKER blat2hints.pl --in=${MOUNTDIR}/${INPUTFILE} --out=${MOUNTDIR}/${PREFIX}.hints.gff
# Choose one run command below
singularity exec instance://BRAKER augustus --species=$SPECIES --hintsfile=${MOUNTDIR}/${PREFIX}.hints.gff --extrinsicCfgFile=${MOUNTDIR}/${CFGFILE} ${MOUNTDIR}/${REF}
#singularity exec instance://BRAKER augustus --species=$SPECIES --hintsfile=${PREFIX}.hints.gff --extrinsicCfgFile=extrinsic.MPE.cfg $REF

singularity instance stop BRAKER
