# SweeD Analysis

This pipeline is based off earlier work by Abraham Morales-Cruz. Notes and code from his earlier work can be found in [SweeD_pipeline_amc.md](https://github.com/GautLab/avo_ref_paper/blob/main/SweeD_analysis/SweeD_pipeline_amc.md).

1. [SweeD_avocado_job.sh](https://github.com/GautLab/avo_ref_paper/blob/main/SweeD_analysis/SweeD_avocado_job.sh) runs SweeD v4.0.0 on all populations using a window size of 10kb. This outputs a file per chromosome per population. Takes roughly 12 hours per population.
2. [combine_SweeD.sh](https://github.com/GautLab/avo_ref_paper/blob/main/SweeD_analysis/combine_SweeD.sh) combines all chromosomes into a single file, yielding one file per population.
3. [plot_results.R](https://github.com/GautLab/avo_ref_paper/blob/main/SweeD_analysis/plot_results.R) is used to plot the loess-smoothed CLR values, and also outputs files containing positions in the top 1% and top 5%.

The outputs from step 1 can be found in [raw_output](https://github.com/GautLab/avo_ref_paper/tree/main/SweeD_analysis/raw_output).
The outputs from steps 2 and 3 can be found in [SweeD_output](https://github.com/GautLab/avo_ref_paper/tree/main/SweeD_analysis/SweeD_output).
