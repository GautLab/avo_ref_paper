library(ggplot2)
library(ggthemes) # this is not necessary, remove "theme_few()" if you can't install this.

setwd("C:/Users/Skylar2/Code/avo_ref_paper/SweeD_analysis")
scan("pops.list", what = "character") -> pops

for (i in 1:length(pops)) {
  # Reading parsed SweeD output and naming columns
  input <- file.path(paste0("SweeD_output/allchrs.", pops[i], ".10k.SweeD.txt"))
  tab <- read.table(input)
  colnames(tab) <- c("chr", "Position", "Likelihood", "Alpha", "StartPos", "EndPos")

  # Creating local regressions
  seq(1, nrow(tab)) -> index
  cbind(index, tab) -> tab
  predict(loess(tab$Likelihood ~ tab$index, span=0.008)) -> sweep_smooth # feel free to try different "span" values!
  as.data.frame(cbind(tab$chr, tab$Position, sweep_smooth, deparse.level = 1 )) -> sweep_smoothdf
  colnames(sweep_smoothdf) <- c("chr", "mid", "sweep_loess")

  # Calculating 99 and 95 quantiles from the regressed data
  quantile(sweep_smoothdf$sweep_loess, 0.99) -> q99
  quantile(sweep_smoothdf$sweep_loess, 0.95) -> q95

  sweep_smoothdf[sweep_smoothdf$sweep_loess >= quantile(sweep_smoothdf$sweep_loess, 0.99),] -> top1
  sweep_smoothdf[sweep_smoothdf$sweep_loess >= quantile(sweep_smoothdf$sweep_loess, 0.95),] -> top5
  
  top1_filename <- file.path(paste0("SweeD_output/", pops[i], ".SweeD.loess.top1.txt"))
  top5_filename <- file.path(paste0("SweeD_output/", pops[i], ".SweeD.loess.top5.txt"))
  
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
  
  plot_file <- file.path(paste0("SweeD_output/", pops[i], ".SweeD.loess.q99-95.pdf"))
  ggsave(plot_file, plot, height=4, width=15)
}

