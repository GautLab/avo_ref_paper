**Running SweeD**

```sh
# I installed sweed v4 in the path below, let me know if you have problems accesing it 
# /gpool/amc/programs/sweed_v4.0.0/SweeD-P

#Note: Here I'm assuming you will have a vcf files for each population

# Creating a file with the population names 
printf "pop1\npop2\npop3\n" > pops
# Creating a dir for each population
mkdir ${i}
# Running all pops in a loop
for i in $(cat pops); do cd ${i}; /gpool/amc/programs/sweed_v4.0.0/SweeD-P -name ${i}.10k -input ${i}.vcf -reports -threads 10 -grid 10000 ; cd ../ ; done

# Configuration for slurm 

#!/bin/bash -l
######################
##SLURM CONFIGURATION#
######################
#Number of cores/tasks
#SBATCH -n 10

#Number of Nodes
#SBATCH -N 1
#SBATCH --mem=50G
```

**Parsing SweeD results**

SweeD creates a file for each chromosome. In this example the vcf file is sorted from 1 to 19 chrs, so it is easy to parse and combine.

```sh
for i in $(cat pops); do for z in {01..19}; do cd ${i}/; cat SweeD_Report.${i}.10kG.${z}  | grep -v "Likelihood" | sed "s/^/chr${z}\t/"  >> allchrs.${i}.10k.SweeD.txt ; cd ../;  done ; done 
```

**Calculating top quantiles and plotting multiple pops as a loop**

This next section is all in R. This code will write files with the top 1% and top 5% snps and creates the plots in the second part. 

```sh
library(ggplot2)
library(ggthemes) # this is not necessary, remove "theme_few()" if you can't install this.

scan("pops", what = "character") -> pops

for (i in 1:length(pops)) {
  # Reading parsed SweeD output and naming columns
  input <- file.path(paste0("allchrs.", pops[i], ".10k.SweeD.txt"))
  tab <- read.table(input)
  colnames(tab) <- c("chr", "Position", "Likelihood", "Alpha", "StartPos", "EndPos")

  # Creating local regressions
  seq(1, nrow(tab)) -> index
  cbind(index, tab) -> tab
  predict(loess(tab$Likelihood ~ tab$index, span=0.008)) -> sweep_smooth # feel free to try diffent "span" values!
  as.data.frame(cbind(tab$chr, tab$Position, sweep_smooth, deparse.level = 1 )) -> sweep_smoothdf
  colnames(sweep_smoothdf) <- c("chr", "mid", "sweep_loess")

  # Calculating 99 and 95 quantiles from the regressed data
  quantile(sweep_smoothdf$sweep_loess, 0.99) -> q99
  quantile(sweep_smoothdf$sweep_loess, 0.95) -> q95

  sweep_smoothdf[sweep_smoothdf$sweep_loess >= quantile(sweep_smoothdf$sweep_loess, 0.99),] -> top1
  sweep_smoothdf[sweep_smoothdf$sweep_loess >= quantile(sweep_smoothdf$sweep_loess, 0.95),] -> top5
  
  top1_filename <- file.path(paste0(pops[i], ".SweeD.loess.top1.txt"))
  top5_filename <- file.path(paste0(pops[i], ".SweeD.loess.top5.txt"))
  
  write.table(top1, top1_filename, quote=F)
  write.table(top5, top5_filename, quote=F)
  
  # Plotting 
  ggplot(data=sweep_smoothdf, aes(x=mid/1000000,y=sweep_loess)) + 
    geom_line(size=0.5, linejoin="bevel", color="black") +
    theme_few() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1,size = 10))  +
    xlab("Position (Mb)") +
    ylab("SweeD CLR (loess)") +
    facet_wrap(~chr, scales="free_x", nrow=2) +
    geom_hline(yintercept = q99, linetype="dashed", color="red") + 
    geom_hline(yintercept = q95, linetype="dashed", color="blue") + 
    ggtitle(pops[i]) -> plot
  
  plot_file <- file.path(paste0(pops[i], ".SweeD.loess.q99-95.pdf"))
  ggsave(plot_file, plot, height=4, width=15)
}
```
