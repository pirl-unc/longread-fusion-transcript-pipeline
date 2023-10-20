library(dplyr)
library(GenomicRanges)

        tab <- readLines(con='bbn963_longgf.txt')
        sw <- startsWith(tab, 'SumGF')
        ss1 <- strsplit(tab[sw], ' ')
end1 <- paste0('chr', vapply(ss1, function(x) x[6], character(1)))
end2 <- paste0('chr', vapply(ss1, function(x) x[7], character(1)))

seqnameo <- paste0('chr', 1:20)
seqnameo <- c(seqnameo, 'chrY', 'chrX')

longgf_starts <- GRanges(seqinfo = seqnameo, end1)
longgf_ends <- GRanges(seqinfo = seqnameo, end2)

tab <- read.csv('jaffa_results_bbn963.csv', header=T)
tabj <- read.csv('jaffa_results_bbn963.csv', header=T)
chrom1 <- tab['chrom1'][,1]
#chrom1 <- gsub("^.{0,3}", "", chrom1)
chrom2 <- tab['chrom2'][,1]
#chrom2 <- gsub("^.{0,3}", "", chrom2)
base1 <- tab$base1
base2 <- tab$base2

jaffa_fix <- chrom2 %in% seqnameo

chrom1 <- chrom1[jaffa_fix]
base1 <- base1[jaffa_fix]
chrom2 <- chrom2[jaffa_fix]
base2 <- base2[jaffa_fix]

jaffal_starts <- GRanges(seqinfo = seqnameo, chrom1, base1)
jaffal_ends <- GRanges(seqinfo = seqnameo, chrom2, base2)

tab <- read.csv('short_bb1.csv', header=T)
tabs1 <- read.csv('short_bb1.csv', header=T)
breakpoint1 <- paste0('chr', tab$breakpoint1)
breakpoint2 <- paste0('chr', tab$breakpoint2)

bbn963_370T_start <- GRanges(seqinfo = seqnameo, breakpoint1)
bbn963_370T_end <- GRanges(seqinfo = seqnameo, breakpoint2)

tab <- read.csv('short_bb2.csv', header=T)
tabs2 <- read.csv('short_bb2.csv', header=T)
breakpoint1 <- paste0('chr', tab$breakpoint1)
breakpoint2 <- paste0('chr', tab$breakpoint2)

bbn963_389T_start <- GRanges(seqinfo = seqnameo, breakpoint1)
bbn963_389T_end <- GRanges(seqinfo = seqnameo, breakpoint2)

tab <- read.csv('short_bb3.csv', header=T)
tabs3 <- read.csv('short_bb3.csv', header=T)
breakpoint1 <- paste0('chr', tab$breakpoint1)
breakpoint2 <- paste0('chr', tab$breakpoint2)

bbn963_390T_start <- GRanges(seqinfo = seqnameo, breakpoint1)
bbn963_390T_end <- GRanges(seqinfo = seqnameo, breakpoint2)

maxgap <- 10000
maxgap1 <- 1000
maxgap2 <- 1000
maxgap3 <- 1000

longgf_jaffal_s <- findOverlaps(longgf_starts, jaffal_starts, maxgap=maxgap)
longgf_jaffal_e <- findOverlaps(longgf_ends, jaffal_ends, maxgap=maxgap)

bbn_1_2s <- findOverlaps(bbn963_370T_start, bbn963_389T_start, maxgap=maxgap1)
bbn_1_2e <- findOverlaps(bbn963_370T_end, bbn963_389T_end, maxgap=maxgap1)
bbn_1_2 <- bbn_1_2s[which(do.call(paste0, as.data.frame(bbn_1_2s)) %in% do.call(paste0, as.data.frame(bbn_1_2e)))]

bbn_1_3s <- findOverlaps(bbn963_370T_start, bbn963_390T_start, maxgap=maxgap1)
bbn_1_3e <- findOverlaps(bbn963_370T_end, bbn963_390T_end, maxgap=maxgap1)
bbn_1_3 <- bbn_1_3s[which(do.call(paste0, as.data.frame(bbn_1_3s)) %in% do.call(paste0, as.data.frame(bbn_1_3e)))]

bbn_2_3s <- findOverlaps(bbn963_389T_start, bbn963_390T_start, maxgap=maxgap1)
bbn_2_3e <- findOverlaps(bbn963_389T_end, bbn963_390T_end, maxgap=maxgap1)
bbn_2_3 <- bbn_2_3s[which(do.call(paste0, as.data.frame(bbn_2_3s)) %in% do.call(paste0, as.data.frame(bbn_2_3e)))]

ii <- inner_join(as.data.frame(bbn_1_2), as.data.frame(bbn_1_3), by='queryHits')
ii <- ii[,-c(1)]
bbn_all <- bbn_2_3s[which(do.call(paste0, ii) %in% do.call(paste0, as.data.frame(bbn_2_3s)))]

longgf_bbn1_s <- findOverlaps(longgf_starts, bbn963_370T_start, maxgap=maxgap2)
longgf_bbn1_e <- findOverlaps(longgf_ends, bbn963_370T_end, maxgap=maxgap2)
longgf_bbn2_s <- findOverlaps(longgf_starts, bbn963_389T_start, maxgap=maxgap2)
longgf_bbn2_e <- findOverlaps(longgf_ends, bbn963_389T_end, maxgap=maxgap2)
longgf_bbn3_s <- findOverlaps(longgf_starts, bbn963_390T_start, maxgap=maxgap2)
longgf_bbn3_e <- findOverlaps(longgf_ends, bbn963_390T_end, maxgap=maxgap2)

jaffal_bbn1_s <- findOverlaps(jaffal_starts, bbn963_370T_start, maxgap=maxgap3)
jaffal_bbn1_e <- findOverlaps(jaffal_ends, bbn963_370T_end, maxgap=maxgap3)
jaffal_bbn2_s <- findOverlaps(jaffal_starts, bbn963_389T_start, maxgap=maxgap3)
jaffal_bbn2_e <- findOverlaps(jaffal_ends, bbn963_389T_end, maxgap=maxgap3)
jaffal_bbn3_s <- findOverlaps(jaffal_starts, bbn963_390T_start, maxgap=maxgap3)
jaffal_bbn3_e <- findOverlaps(jaffal_ends, bbn963_390T_end, maxgap=maxgap3)
