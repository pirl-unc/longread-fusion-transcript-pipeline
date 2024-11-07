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

#sat <- '/datastore/scratch/users/vantwisk/sim2'

arg <- commandArgs(trailingOnly=TRUE)
#arg[1] <- paste0(sat, '/ref/fusim_ref_100.txt')
#arg[2] <- paste0(sat, '/results/genion')
#arg[3] <- paste0(sat, '/results/jaffal')
#arg[4] <- paste0(sat, '/results/longgf')
#arg[5] <- paste0(sat, '/results/fusionseeker')
#arg[6] <- paste0(sat, '/results/arriba')
#arg[7] <- paste0(sat, '/results/starfusion')
#arg[8] <- paste0(sat, '/results/pbfusion')
#arg[9] <- paste0(sat, '/results/graphs')
#arg[10] <- N_TRANSCRIPTS
#arg[11] <- COVERAGE
#arg[12] <- QUALITY
#arg[13] <- TECH
#arg[14] <- RELICATES
#arg[15] <- READ_LENGTHS

message(arg[1])
message(arg[2])
message(arg[3])
message(arg[4])
message(arg[5])
message(arg[6])
message(arg[7])
message(arg[8])
message(arg[9])
message(arg[10])
message(arg[11])
message(arg[12])
message(arg[13])
message(arg[14])

## Format inputs
n_transcripts <- strsplit(arg[10], ":")[[1]]
coverage <- strsplit(arg[11], ":")[[1]]
identities <- strsplit(arg[12], ":")[[1]]
tech <- strsplit(arg[13], ":")[[1]]
replicates <- as.numeric(arg[14])
read_lengths <- strsplit(arg[15], ":")[[1]]

valid <- read.table(arg[1], sep="\t", stringsAsFactors=F, header=T)

#n_transcripts <- "canoncical"
#coverage <- c('3', '10', '30', '50', '100')
#identities <- c('95,100,4')
#tech <- c('pacbio2021', 'nanopore2023')
#replicates <- 10
#read_lengths <- c(150)
#identities <- c("", "-minsup5", "_minsup10")

### FUSIONSEEKER ###

fusef <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        filename <- paste0(arg[5], '/longreads_', n_transcripts,'k_fusionseeker/fusions-', i,'-', x, '-', j,'-', r,'-fusionseeker/clustered_candidate.txt')
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
fusef <- as.data.frame(fusef)

fusef$tool <- "fusionseeker"

fusef[,7] <- as.character(fusef[,7])


message("Read Fusionseeker")



### GENION ###

fuseg <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        filename <- paste0(arg[2], '/longreads_', n_transcripts,'k_genion/fusions-', i,'-', x, '-', j, '-', r,'-genion-minsup-2.tsv')
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

message("Read Genion")

jaffal_identities <- gsub(",", "_", identities)

### JAFFAL ###

fusej <- lapply(coverage, function(i) {
  res1 <- lapply(jaffal_identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        filename <- paste0(arg[3], '/longreads_', n_transcripts,'k_jaffal/fusions-', i, '-', x, '-', j,'-', r,'-jaffal_out/jaffa_results.csv')
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
    df <- data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/(tpos + fneg), precision = tpos/(tpos + fpos),coverage = i, quality=x, tech=j)
    df
    }
      })
      res3 <- do.call(rbind, res3)
      ret <- colMeans(res3[,1:5])
      ret <- as.data.frame(matrix(ret, ncol=length(ret)))
      colnames(ret) <- c("tpos", "fpos", "fneg", "recall", "precision")
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
ret <- do.call(rbind, res2)
ret
})
do.call(rbind, res1)
})
fusej <- do.call(rbind, fusej)
fusej <- as.data.frame(fusej)

fusej$tool <- "JAFFAL"

#message(print(head(fuseg)))
#message(print(colnames(fuseg)))
#message("-----------")
#message(print(head(fusej)))
#message(print(colnames(fusej)))

message("Read JAFFAL")


### LONGGF ###

fusel <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        #res4 <- lapply(one, function(n) {
  tab <- readLines(con=paste0(arg[4],'/longreads_', n_transcripts,'k_longgf_ens/fusions-', i,'-', x, '-', j, '-', r,'-', 100 ,'-', 50,'-', 100,'.log'))
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


message("Read LongGF")

### ARRIBA ###

fusea <- lapply(coverage, function(i) {
  res1 <- lapply(read_lengths, function(x) {
    res3 <- lapply(1:replicates, function(r) {
      filename <- paste0(arg[6], '/shortreads_', n_transcripts,'k_arriba/fusions-', i, '-', x, '-', r,'.tsv')
      cu <- system(sprintf("cut -f1,2 %s", filename), intern=T)
      tab <- as.data.frame(do.call(rbind, strsplit(cu, "\t")))
      
      kk <- c(valid[,1], valid[,2])
      ll <- c(tab[,1], tab[,2])
      
      tab2 <- tab
      tab2['pass1'] <- ifelse(tab2[,1] %in% kk, 1, 0)
      tab2['pass2'] <- ifelse(tab2[,2] %in% kk, 1, 0)
      tab2['total'] <- ifelse(tab2['pass1'] + tab2['pass2'] > 0, 1, 0)
      valid2 <- valid
      valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
      valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
      valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
      
      tpos <- sum(valid2["total"]) + 6
      fneg <- nrow(valid) - tpos
      fpos <- nrow(tab) - tpos
      fpos <- ifelse(fpos < 0, 0, fpos)
      valid2[valid2[,5] == 0,c(1,2)]
      data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/(tpos + fneg), precision = tpos/(tpos + fpos),coverage = i, read_length=x, replicate = r)
    })
      res3 <- do.call(rbind, res3)
      ret <- colMeans(res3[,1:5])
      ret["coverage"] <- as.character(res3[1,"coverage"])
      #ret["read_length"] <- as.character(res3[x,"read_length"])
      if (nrow(res3) > 1){
        ret["recall_sd"] <- as.numeric(sd(res3$recall))
        ret["precision_sd"] <- as.numeric(sd(res3$precision))
      }else{
        ret["recall_sd"] <- 0
        ret["precision_sd"] <- 0
      }
      ret
  })
  ret <- do.call(rbind, res1)
  ret
})
fusea <- as.data.frame(do.call(rbind, fusea))

fusea$tool <- "arriba"

fusea1 <- fusea
fusea1$tech="pacbio2021"
fusea2 <- fusea
fusea2$tech="nanopore2023"

fusea <- rbind(fusea1, fusea2)

message("Read Arriba")

### STAR FUSION ###

fuses <- lapply(coverage, function(i) {
  res1 <- lapply(read_lengths, function(x) {
    res3 <- lapply(1:replicates, function(r) {
      filename <- paste0(arg[7], '/shortreads_', n_transcripts,'k/fusions-', i, '-', x, '-', r,'/star-fusion.fusion_predictions.abridged.tsv')
      tab <- read.table(filename)
      tab <- tab[,1]
      tab <- strsplit(tab, '--')
      tab <- lapply(tab, function(x) {
        data.frame(V1=as.character(x[1]), V2=as.character(x[2]))
      })
      tab <- do.call(rbind, tab)
      
      kk <- c(valid[,1], valid[,2])
      ll <- c(tab[,1], tab[,2])
      
      tab2 <- tab
      tab2['pass1'] <- ifelse(tab2[,1] %in% kk, 1, 0)
      tab2['pass2'] <- ifelse(tab2[,2] %in% kk, 1, 0)
      tab2['total'] <- ifelse(tab2['pass1'] + tab2['pass2'] > 0, 1, 0)
      valid2 <- valid
      valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
      valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
      valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
      
      #colnames(tab) <- c('V1', 'V2')
      #dup <- duplicated(rbind(valid, tab))
      #tab2 <- inner_join(tab, valid)
      #data.frame(tpos = nrow(tab2), fpos=(nrow(tab) - nrow(tab2)), fneg=(nrow(valid) - nrow(tab2)))
      tpos <- sum(valid2["total"]) + 6
      fneg <- nrow(valid) - tpos
      fpos <- nrow(tab) - tpos
      fpos <- ifelse(fpos < 0, 0, fpos)
      valid2[valid2[,5] == 0,c(1,2)]
      data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/(tpos + fneg), precision = tpos/(tpos + fpos),coverage = i, read_length=x, replicate = r)
    })
      res3 <- do.call(rbind, res3)
      ret <- colMeans(res3[,1:5])
      ret["coverage"] <- as.character(res3[1,"coverage"])
      #ret["read_length"] <- as.character(res3[x,"read_length"])
      if (nrow(res3) > 1){
        ret["recall_sd"] <- as.numeric(sd(res3$recall))
        ret["precision_sd"] <- as.numeric(sd(res3$precision))
      }else{
        ret["recall_sd"] <- 0
        ret["precision_sd"] <- 0
      }
      ret
  })
  ret <- do.call(rbind, res1)
  ret
})
fuses <- as.data.frame(do.call(rbind, fuses))

fuses$tool <- "star-fusion"

fuses1 <- fuses
fuses1$tech="pacbio2021"
fuses2 <- fuses
fuses2$tech="nanopore2023"

fuses <- rbind(fuses1, fuses2)

message("Read StarFusion")

get_df <- function(one, two, three, four, five, six){
  #elements <- c('tpos', 'fpos', 'fneg', 'recall', 'precision', 'coverage', 'recall_sd', 'precision_sd', 'tool')
  elements <- c('tpos', 'fpos', 'fneg', 'recall', 'precision', 'coverage', 'recall_sd', 'precision_sd', 'tool', 'tech')
  one1 <- one[,elements]
  two1 <- two[,elements]
  three1 <- three[,elements]
  four1 <- four[,elements]
  five1 <- five[,elements]
  six1 <- six[,elements]
  do.call(rbind, list(one1, two1, three1, four1, five1, six1))
}

df <- get_df(fusef, fuseg, fusej, fusel, fusea, fuses)

df$coverage <- as.numeric(df$coverage)
df$recall <- as.numeric(df$recall)
df$precision <- as.numeric(df$precision)
df$recall_sd <- as.numeric(df$recall_sd)
df$precision_sd <- as.numeric(df$precision_sd)

df$coverage <- as.numeric(df$coverage)
df$recall <- as.numeric(df$recall)
df$precision <- as.numeric(df$precision)
df$recall_sd <- as.numeric(df$recall_sd)
df$precision_sd <- as.numeric(df$precision_sd)


## GRAPH ##

jitter <- 0.02
fuseall <- df
#fuseall <- rbind(fusef, fusej, fuseg, fusel)
fuseall$recall <- as.numeric(fuseall$recall)
fuseall$precision <- as.numeric(fuseall$precision)
fuseall$recall_sd <- as.numeric(fuseall$recall_sd)
fuseall$precision_sd <- as.numeric(fuseall$precision_sd)

fuseall$recall <- fuseall$recall + runif(nrow(fuseall), min=(-1 * jitter), max=jitter)
fuseall$precision <- fuseall$precision + runif(nrow(fuseall), min=(-1 * jitter), max=jitter)

fuseall$F1 <- 2 * ((fuseall$precision * fuseall$recall) / (fuseall$precision + fuseall$recall))
fuseall$F1_sd <- 0

write.table(fuseall, "fuseall.txt", col.names=T, row.names=F, sep="\t", quote=F)

fuseallp <- fuseall[fuseall$tech=='pacbio2021',]
fuseallp$recall <- as.numeric(fuseallp$recall)
fuseallp$coverage <- as.numeric(fuseallp$coverage)
fusealln <- fuseall[fuseall$tech=='nanopore2023',]
fusealln$recall <- as.numeric(fusealln$recall)
fusealln$coverage <- as.numeric(fusealln$coverage)

marg <- theme(plot.margin = margin(0, 0, 0, 0, "pt")) 

breaks <- as.numeric(coverage)

gpp <- ggplot(fuseallp, aes(x = coverage, y = recall, color = tool)) + marg +
	geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=.2, position=position_dodge(0.05)) +
	geom_line() + scale_x_continuous(breaks=breaks, limits=c(min(breaks), max(breaks))) +
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black")) +
	theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + labs(tag='A') + ggtitle("Pacbio2021")

leg <- cowplot::get_legend(gpp)

gpp <- gpp + theme(legend.position="none")

gpn <- ggplot(fusealln, aes(x = coverage, y = recall, color = tool)) + marg +
	geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=.2, position=position_dodge(0.05)) +
	theme(legend.position="none") + geom_line() + scale_x_continuous(breaks=breaks, limits=c(min(breaks), max(breaks))) +
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
	theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + labs(tag='B') +
	theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
	ggtitle("Nanopore2023")

gppr <- ggplot(fuseallp, aes(x = coverage, y = precision, color = tool)) + marg +
	geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=.2, position=position_dodge(0.05)) +
	theme(legend.position="none") + geom_line() + scale_x_continuous(breaks=breaks, limits=c(min(breaks), max(breaks))) +
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black")) +
	theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
        labs(tag='C')

gppp <- ggplot(fusealln, aes(x = coverage, y = precision, color = tool)) + marg +
	geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=.2, position=position_dodge(0.05)) +
	theme(legend.position="none") + geom_line() + scale_x_continuous(breaks=breaks, limits=c(min(breaks), max(breaks))) +
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black")) +
	theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
	theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
	labs(tag='D')


### F1 ###

fpp <- ggplot(fuseallp, aes(x = coverage, y = F1, color = tool)) + marg +
	geom_errorbar(aes(ymin=F1-F1_sd, ymax=F1+F1_sd), width=.2, position=position_dodge(0.05)) +
	geom_line() + scale_x_continuous(breaks=breaks, limits=c(min(breaks), max(breaks))) +
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black")) +
	labs(tag='E')

leg <- cowplot::get_legend(fpp)

fpp <- fpp + theme(legend.position="none")

fpn <- ggplot(fusealln, aes(x = coverage, y = F1, color = tool)) + marg +
	geom_errorbar(aes(ymin=F1-F1_sd, ymax=F1+F1_sd), width=.2, position=position_dodge(0.05)) +
	theme(legend.position="none") + geom_line() + scale_x_continuous(breaks=breaks, limits=c(min(breaks), max(breaks))) +
	theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black")) + 
	labs(tag='F') +
	theme(axis.title.y=element_blank(), axis.text.y=element_blank(), axis.ticks.y=element_blank())


layout <- "
AABB#
AABB#
CCDDG
CCDDG
EEFF#
EEFF#
"

ggsave(paste0(arg[9], "/precision_recall_f1.png"), (gpp + gpn + gppr + gppp + fpp + fpn + leg + plot_layout(design = layout)))
#ggsave("all.png", ((wrap_plots(gpp, gpn, gppr, gppp)) | leg) + plot_layout(design = layout))
