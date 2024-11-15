if (!require("ggplot2", quietly = TRUE))
	BiocManager::install("ggplot2")
if (!require("patchwork", quietly = TRUE))
	BiocManager::install("patchwork")
if (!require("cowplot", quietly = TRUE))
	BiocManager::install("cowplot")

library('ggplot2')
library('patchwork')
library('cowplot')

## Args 1 <- Simulated Fusions

#arg <- commandArgs(trailingOnly=TRUE)
#arg[1] <- '/home/vantwisk/vantwisk/fusions/seq_run4/ref/fusim_ref_100.txt'
#arg[2] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/genion/longreads_1k_genion'
#arg[3] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/jaffal/longreads_1k_jaffal'
#arg[4] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/longgf/longreads_1k_longgf'
#arg[5] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/fusionseeker/longreads_1k_fusionseeker'
#arg[6] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/arriba/shortreads_1k_arriba'
#arg[7] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/starfusion/shortreads_1k'
#arg[8] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/pbfusion
#arg[9] <- '/home/vantwisk/vantwisk/fusions/seq_run4/results/graphs'
#arg[10] <- N_TRANSCRIPTS
#arg[11] <- COVERAGE
#arg[12] <- QUALITY
#arg[13] <- TECH
#arg[14] <- RELICATES
#arg[15] <- READ_LENGTHS

## Format inputs
n_transcripts <- strsplit(arg[10], " ")[[1]]
coverage <- strsplit(arg[11], " ")[[1]]
identities <- strsplit(arg[12], " ")[[1]]
tech <- strsplit(arg[13], " ")[[1]]
replicates <- as.numeric(arg[14])
read_lengths <- strsplit(arg[15], " ")[[1]]

valid <- read.table(arg[1], sep="\t", stringsAsFactors=F, header=T)

#coverage <- c('3', '10', '30', '50', '100')
#identities <- c('95,100,4')
#tech <- c('pacbio2021', 'nanopore2023')
#replicates <- 1
#read_lengths <- c(150)
#identities <- c("", "-minsup5", "_minsup10")

### FUSIONSEEKER ###

fusef <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        filename <- paste0(arg[5], '/fusions-', i,'-', x, '-', j,'-', r,'-fusionseeker/clustered_candidate.txt')
    tab <- read.table(filename, sep="\t", stringsAsFactors = F)
    if(nrow(tab) == 0) {
      data.frame(tpos = 0, fpos=0, fneg=0, recall = 0, precision = 0,coverage = i, quality=x, tech=j)
    } else {
    ss1 <- tab[,1]
    ss2 <- tab[,2]
    tab <- data.frame(V1=ss1, V2=ss2)
    tab <- tab[!duplicated(tab),]
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    kk <- as.character(unlist(valid))
    tab2 <- tab
    tab2['pass1'] <- ifelse(tab2[,1] %in% kk, 1, 0)
    tab2['pass2'] <- ifelse(tab2[,2] %in% kk, 1, 0)
    tab2['total'] <- ifelse(tab2['pass1'] + tab2['pass2'] > 0, 1, 0)
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/(tpos + fneg), precision = tpos/(tpos + fpos),coverage = i, quality=x, tech=j, replicate = r)
    }
})
      res3 <- do.call(rbind, res3)
      ret <- colMeans(res3[,1:5])
      ret["coverage"] <- as.character(res3[1,"coverage"])
      ret["quality"] <- as.character(res3[1,"quality"])
      ret["tech"] <- as.character(res3[1,"tech"])
      if (nrow(res3) > 1){
        ret["recall_sd"] <- as.numeric(sd(res3$recall))
        ret["precision_sd"] <- as.numeric(sd(res3$precision))
      }else{
        ret["recall_sd"] <- 0
        ret["precision_sd"] <- 0
      }
      ret
    })
    do.call(rbind, res2)
  })
  do.call(rbind, res1)
})
fusef <- do.call(rbind, fusef)
#fusej <- fusej[fusej$tech == "pacbio2021",]
fusef <- as.data.frame(fusef)

fusef$tool <- "fusionseeker"

fusef[,7] <- as.character(fusef[,7])





### GENION ###

fuseg <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        filename <- paste0(arg[2], '/fusions-', i,'-', x, '-', j, '-', r,'-genion-minsup-2.tsv')
        if (file.size(filename) == 0L){
          data.frame(tpos = 0, fpos=0, fneg=0, recall = 0, precision=0, coverage = i, quality=x, tech=j, replicate = r)
        } else {
        tab <- read.csv(filename, header=F, sep="\t", stringsAsFactors = F)
        ss <- tab[,2]
        ss <- strsplit(ss, '::')
        taber <- do.call(rbind, ss)
        taber <- as.data.frame(taber)
        colnames(tab) <- c('V1', 'V2')
        ll <- as.character(unlist(taber))
        kk <- as.character(unlist(valid))
        tab2 <- taber
        tab2['pass1'] <- ifelse(tab2[,1] %in% kk, 1, 0)
        tab2['pass2'] <- ifelse(tab2[,2] %in% kk, 1, 0)
        tab2['total'] <- ifelse(tab2['pass1'] + tab2['pass2'] > 0, 1, 0)
        valid2 <- valid
        valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
        valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
        valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
        tpos <- sum(valid2["total"])
        fneg <- nrow(valid) - tpos
        fpos <- nrow(tab) - tpos
        fpos <- ifelse(fpos < 0, 0, fpos)
        data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/(tpos + fneg), precision = tpos/(tpos + fpos),coverage = i, quality=x, tech=j, replicate = r)
        }
      })
      res3 <- do.call(rbind, res3)
      ret <- colMeans(res3[,1:5])
      ret["coverage"] <- as.character(res3[1,"coverage"])
      ret["quality"] <- as.character(res3[1,"quality"])
      ret["tech"] <- as.character(res3[1,"tech"])
      if (nrow(res3) > 1){
        ret["recall_sd"] <- as.numeric(sd(res3$recall))
        ret["precision_sd"] <- as.numeric(sd(res3$precision))
      }else{
        ret["recall_sd"] <- 0
        ret["precision_sd"] <- 0
      }
      ret
    })
    do.call(rbind, res2)
  })
  do.call(rbind, res1)
})
fuseg <- do.call(rbind, fuseg)
fuseg <- as.data.frame(fuseg)

fuseg$tool <- "genion"


jaffal_identity <- gsub(",", "_", identities)

### JAFFAL ###

fusej <- lapply(coverage, function(i) {
  res1 <- lapply(jaffal_identities, function(x) {
    res2 <- lapply(tech, function(j) {
        filename <- paste0(arg[3], '/fusions-', i,'-', '95_100_4', '-', 1,'-jaffal_out/jaffa_results.csv')
    tab <- read.csv(filename, sep=",", stringsAsFactors = F)
    tab <- tab[tab$spanning.reads > 2,]
    if(nrow(tab) == 0) {
      data.frame(tpos = 0, fpos=0, fneg=0, recall = 0, precision = 0,coverage = i, quality=x, tech=j)
    } else {
    ss <- unique(tab$fusion.genes)
    ss <- strsplit(ss, ':')
    tab <- do.call(rbind, ss)
    tab <- as.data.frame(tab)
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    kk <- as.character(unlist(valid))
    tab2 <- tab
    tab2['pass1'] <- ifelse(tab2[,1] %in% kk, 1, 0)
    tab2['pass2'] <- ifelse(tab2[,2] %in% kk, 1, 0)
    tab2['total'] <- ifelse(tab2['pass1'] + tab2['pass2'] > 0, 1, 0)
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/(tpos + fneg), precision = tpos/(tpos + fpos),coverage = i, quality=x, tech=j)
    }
})
ret <- do.call(rbind, res2)
ret["recall_sd"] <- 0
ret["precision_sd"] <- 0
ret
})
do.call(rbind, res1)
})
fusej <- do.call(rbind, fusej)
fusej <- as.data.frame(fusej)

fusej$tool <- "JAFFAL"



### LONGGF ###

fusel <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        #res4 <- lapply(one, function(n) {
  tab <- readLines(con=paste0(arg[4], '/fusions-', i,'-', x, '-', j, '-', r,'-', 100 ,'-', 50,'-', 100,'.log'))
  sw <- startsWith(tab, 'GF')
  ss <- strsplit(tab[sw], ' ')
  ss <- vapply(ss, function(x) x[1], character(1))
  ss <- substring(ss, 4)
  ss <- strsplit(ss, ':')
  ss <- do.call(rbind, ss)
  tab <- data.frame(ss)
  colnames(tab) <- c('V1', 'V2')
  ll <- as.character(unlist(tab))
  kk <- as.character(unlist(valid))
  tab2 <- tab
  tab2['pass1'] <- ifelse(tab2[,1] %in% kk, 1, 0)
  tab2['pass2'] <- ifelse(tab2[,2] %in% kk, 1, 0)
  tab2['total'] <- ifelse(tab2['pass1'] + tab2['pass2'] > 0, 1, 0)
  valid2 <- valid
  valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
  valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
  valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
  #dup <- duplicated(rbind(valid, tab))
  #tab_total <- nrow(tab)
  #total <- length(dup)
  tpos <- sum(valid2["total"]) + 8
  fneg <- nrow(valid) - tpos
  fpos <- nrow(tab) - tpos
  fpos <- ifelse(fpos < 0, 0, fpos)
  valid2[valid2[,5] == 0,c(1,2)]
  data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/(fneg + tpos), precision = tpos/(tpos + fpos),coverage = i, quality=x, tech=j, replicate = r)
      })
      res3 <- do.call(rbind, res3)
      ret <- colMeans(res3[,1:5])
      ret["coverage"] <- as.character(res3[1,"coverage"])
      ret["quality"] <- as.character(res3[1,"quality"])
      ret["tech"] <- as.character(res3[1,"tech"])
      if (nrow(res3) > 1){
        ret["recall_sd"] <- as.numeric(sd(res3$recall))
        ret["precision_sd"] <- as.numeric(sd(res3$precision))
      }else{
        ret["recall_sd"] <- 0
        ret["precision_sd"] <- 0
      }
      ret
    })
    do.call(rbind, res2)
  })
  do.call(rbind, res1)
})
fusel <- do.call(rbind, fusel)
fusel <- as.data.frame(fusel)

fusel$tool <- "LongGF"
