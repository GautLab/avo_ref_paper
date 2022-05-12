#!/bin/bash
#SBATCH -J buscopa		# jobname
#SBATCH -o buscopa.o%A.%a	# jobname.o%j for single (non array) jobs jobname.o%A.%a for array jobs
#SBATCH -e buscopa.e%A.%a	# error file name A is the jobid and a is the arraytaskid
#SBATCH -a 1-4			# start and stop of the array start-end
###SBATCH -n 1			# -n, --ntasks=INT Maximum number of tasks. Use for requesting a whole node. env var SLURM_NTASKS
#SBATCH -c 8			# -c, --cpus-per-task=INT The # of cpus/task. env var for threads is SLURM_CPUS_PER_TASK
#SBATCH -p p1			# queue (partition) -- normal, development, largemem, etc.
###SBATCH --mem-per-cpu=1750
###SBATCH -t 48:00:00		# run time (dd:hh:mm:ss) - 1.5 hours
###SBATCH --mail-user=solarese@uci.edu
###SBATCH --mail-type=begin	# email me when the job starts
###SBATCH --mail-type=end	# email me when the job finishes

source /networkshare/.mybashrc
export AUGUSTUS_CONFIG_PATH="/networkshare/bin/augustus-3.2.2/config"

#source /networkshare/.miniconda3
#conda activate busco3
#PATH=/networkshare/bin/hmmer-3.1b2-linux-intel-x86_64/binaries:$PATH
#PATH=/networkshare/bin/BRAKER_v1.9:$PATH

#INPUTTYPE="tran"
INPUTTYPE="geno"
MYLIBDIR="/networkshare/bin/busco/lineages/"

#drosophila
#MYLIB="diptera_odb9"
#SPTAG=""

#vitis vinifera & vignis radiata
MYLIB="embryophyta_odb9"
SPTAG="arabidopsis"

#zea mayz
#MYLIB="embryophyta_odb9"
#OPTIONS="${OPTIONS} -sp 4577"
#SPTAG="mayz"

#heliconius
#MYLIB="insecta_odb9"
#SPTAG="heliconius_melpomene1"

#bony fish
#MYLIB="actinopterygii_odb9"
#SPTAG="zebrafish"

OPTIONS="-l ${MYLIBDIR}${MYLIB} -sp ${SPTAG}"

#SLURM_ARRAY_TASK_ID=1
#SLURM_CPUS_PER_TASK=11
#mkdir -p busco
#for file in $(ls *.fasta)
#do
#for i in $(cat failedjoblist.txt)
#do
   #file=$(cut -f1 -d":")
   #SLURM_ARRAY_TASK_ID=$(cut -f2 -d":")
   rm -rf busco/busco${SLURM_ARRAY_TASK_ID}
   mkdir -p busco
   TMPDIR="./busco/busco${SLURM_ARRAY_TASK_ID}"
   mkdir -p $TMPDIR
   #TMPDIR="./busco${SLURM_ARRAY_TASK_ID}"
   CWDIR=$(pwd)
   
   JOBFILE="jobfile.txt"
   SEED=$(head -n ${SLURM_ARRAY_TASK_ID} ${JOBFILE} | tail -n 1)
   #SEED=${file}
   cd ${TMPDIR}
   #CWDIR=$(pwd)
   
   echo "Begin analysis on ${SEED}"
   #removes escape chars and spaces. bug fix for mummer. mummer will not take escape characters and spaces in fasta headers
   echo "Begin removing invalid characters in header on ${SEED}"
   ln -sf ../../${SEED}
   cat ${SEED} | sed -r 's/[/ =,\t|]+/_/g' | awk -F "_" '{ if (/^>/) {printf($1"_"$2"\n")} else {print $0} }' > $(basename ${SEED} .fasta)_new.fasta
   QRY=$(basename ${SEED} .fasta)_new.fasta
   #QRY=${SEED}
   
   #echo "Begin quast analysis on ${QRY}"
   #quastrun="quast.py -t ${SLURM_CPUS_PER_TASK} ${QRY} -o quast"
   #echo $quastrun
   #$quastrun
   echo "End quast analysis, cat results and begin busco run"
   buscorun="BUSCO.py -c ${SLURM_CPUS_PER_TASK} -i ${QRY} -m ${INPUTTYPE} -o $(basename ${QRY} .fasta)_${MYLIB}_${SPTAG} ${OPTIONS} -t ./run_$(basename ${QRY} .fasta)_${MYLIB}_${SPTAG}/tmp"
   echo $buscorun
   $buscorun
   echo "End busco run and cat results"
   cat quast/report.txt > ${CWDIR}/$(basename ${QRY} .fasta)_scoresreport.txt
   cat run_$(basename ${QRY} .fasta)_${MYLIB}_${SPTAG}/short*.txt >> ${CWDIR}/$(basename ${QRY} .fasta)_scoresreport.txt
   #cd ../../
   #tar czf busco${SLURM_ARRAY_TASK_ID}.tar.gz busco${SLURM_ARRAY_TASK_ID}
   #rm -rf busco${SLURM_ARRAY_TASK_ID}
   echo "Finished on ${QRY}"
   #let SLURM_ARRAY_TASK_ID=${SLURM_ARRAY_TASK_ID}+1
#done
