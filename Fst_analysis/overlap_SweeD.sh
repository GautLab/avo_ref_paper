join -t $'\t' -1 4 -2 4 -o 1.1,1.2,1.3,1.4 Fst.top1pct.Guatemalan_v_Lowland.genes.bed /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/SweeD_output/allchrs.guatemalan.10k.SweeD.top1.genes.bed > Fst.SweeD.overlap.Guatemalan_v_Lowland.guatemalan.genes.bed

join -t $'\t' -1 4 -2 4 -o 1.1,1.2,1.3,1.4 Fst.top1pct.Guatemalan_v_Lowland.genes.bed /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/SweeD_output/allchrs.lowland.10k.SweeD.top1.genes.bed > Fst.SweeD.overlap.Guatemalan_v_Lowland.lowland.genes.bed

join -t $'\t' -1 4 -2 4 -o 1.1,1.2,1.3,1.4 Fst.top1pct.Mexican_v_Guatemalan.genes.bed /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/SweeD_output/allchrs.guatemalan.10k.SweeD.top1.genes.bed > Fst.SweeD.overlap.Mexican_v_Guatemalan.guatemalan.genes.bed

join -t $'\t' -1 4 -2 4 -o 1.1,1.2,1.3,1.4 Fst.top1pct.Mexican_v_Guatemalan.genes.bed /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/SweeD_output/allchrs.mexican.10k.SweeD.top1.genes.bed > Fst.SweeD.overlap.Mexican_v_Guatemalan.mexican.genes.bed

join -t $'\t' -1 4 -2 4 -o 1.1,1.2,1.3,1.4 Fst.top1pct.Mexican_v_Lowland.genes.bed /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/SweeD_output/allchrs.lowland.10k.SweeD.top1.genes.bed > Fst.SweeD.overlap.Mexican_v_Lowland.lowland.genes.bed

join -t $'\t' -1 4 -2 4 -o 1.1,1.2,1.3,1.4 Fst.top1pct.Mexican_v_Lowland.genes.bed /gpool/swyant/projects/avo_ref_paper/SweeD_analysis/SweeD_output/allchrs.mexican.10k.SweeD.top1.genes.bed > Fst.SweeD.overlap.Mexican_v_Lowland.mexican.genes.bed
