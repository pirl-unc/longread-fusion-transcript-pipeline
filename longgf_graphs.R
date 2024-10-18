valid <- read.table('hs_fusion3.txt', stringsAsFactors=F, header=T)
colnames(valid) <- c('V1', 'V2')

valid <- read.table('longread-fusion-transcript-pipeline/training_fusions.txt', stringsAsFactors=F, header=T)
colnames(valid) <- c('V1', 'V2')

one <- c(10, 30, 50, 100, 300, 500)
two <- c(10, 30, 50, 100, 300, 500)
three <- c(10, 30, 50, 100, 300, 500)

n <- 50

coverage <- c('3', '5', '10', '30', '50', '100')
identities <- c('87,97,5', '75,90,8', '95,100,4')
tech <- c('pacbio2016')
#tech <- c(10, 30, 50, 100, 300, 500)
replicates <- 10
#identities <- c("", "_minoverlap100")
#identities <- c("", "_minsup5", "_minsup10")

fusec <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        #res4 <- lapply(one, function(n) {
        tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/longread-fusion-transcript-pipeline/longreads_training1k_longgf_control/fusions-', i,'-', x, '-', j,'-', r, '-', 100, '-', 50, '-', 100,'.log'))
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
        tpos <- sum(valid2["total"])
        fneg <- nrow(valid) - tpos
        fpos <- nrow(tab) - tpos
        fpos <- ifelse(fpos < 0, 0, fpos)
        valid2[valid2[,5] == 0,c(1,2)]
        data.frame(tpos = tpos, fpos=fpos, fneg=fneg, recall = tpos/429, precision = tpos/(tpos + fpos),coverage = i, quality=x, tech=j, replicate = r)
      })
      res3 <- do.call(rbind, res3)
      ret <- colMeans(res3[,1:5])
      ret["coverage"] <- as.character(res3[1,"coverage"])
      ret["quality"] <- as.character(res3[1,"quality"])
      ret["tech"] <- as.character(res3[1,"tech"])
      ret["recall_sd"] <- as.character(sd(res3$recall))
      ret["precision_sd"] <- as.character(sd(res3$precision))
      ret
      #res3
    })
    do.call(rbind, res2)
    #res2
  })
  do.call(rbind, res1)
  #res1
})
fusec <- do.call(rbind, fusec)
fusec <- as.data.frame(fusec)

#tech <- c(10, 30, 50, 100, 300, 500)

fusel <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        #res4 <- lapply(one, function(n) {
  tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/longread-fusion-transcript-pipeline/longreads_training1k_longgf/fusions-', i,'-', x, '-', j, '-', r,'-', 100 ,'-', 50,'-', 100,'.log'))
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
      ret["recall_sd"] <- as.character(sd(res3$recall))
      ret["precision_sd"] <- as.character(sd(res3$precision))
      ret
      #res3
    })
    do.call(rbind, res2)
    #res2
  })
  do.call(rbind, res1)
  #res1
})
fusel <- do.call(rbind, fusel)
fusel <- as.data.frame(fusel)

fusel$tool <- "LongGF"

fusel1 <- fusel[fusel$quality == "87,97,5",]

fusel[,1] <- as.numeric(as.character(fusel[,1]))
fusel[,2] <- as.numeric(as.character(fusel[,2]))
fusel[,3] <- as.numeric(as.character(fusel[,3]))
fusel[,4] <- as.numeric(as.character(fusel[,4]))
fusel[,5] <- as.numeric(as.character(fusel[,5]))
fusel[,6] <- as.numeric(as.character(fusel[,6]))
fusel[,9] <- as.numeric(as.character(fusel[,9]))
fusel[,10] <- as.numeric(as.character(fusel[,10]))
fuselp <- fusel # fusel[fusel$tech == "pacbio2016",]
fuselg <- fusel[fusel$tech == "nanopore2020",]

fuselp$recall <- fuselp$recall + rnorm(nrow(fuselp), sd=0.01)

colnames(fuselp) <- c('tpos', 'fpos', 'fneg' ,'recall' ,'precision' ,'coverage', 'quality', 'min_overlap_length', 'recall_sd', 'precision_sd')

plot_varied <- function(fusel, quality)
{
  df <- fusel[fusel$quality == quality,]
  
  ggplot(df, aes(x = coverage, y = recall, color = min_overlap_length, group=min_overlap_length)) +
    geom_line() + 
    geom_point() +
    #guides(fill=guide_legend(title="bin-size")) +
    geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                  position=position_dodge(0.05)) +
    ggtitle("LongGF Pacbio2016 recall with coverage and min_overlap_length")
}

library(ggplot2)

x <- 1:10
y <- 3*x+25
id <- order(x)

AUC <- sum(diff(x[id])*rollmean(y[id],2))

plot_AUCPR <- function(fusel) {
  
  fusel[,1] <- as.numeric(as.character(fusel[,1]))
  fusel[,2] <- as.numeric(as.character(fusel[,2]))
  fusel[,3] <- as.numeric(as.character(fusel[,3]))
  fusel[,4] <- as.numeric(as.character(fusel[,4]))
  fusel[,5] <- as.numeric(as.character(fusel[,5]))
  fusel[,6] <- as.numeric(as.character(fusel[,6]))
  fusel[,9] <- as.numeric(as.character(fusel[,9]))
  fusel[,10] <- as.numeric(as.character(fusel[,10]))
  x <- as.numeric(fusel1k$recall)
  y <- as.numeric(fusel1k$precision)
  id <- order(x)
  
  AUC <- sum(diff(x[id])*rollmean(y[id],2))
  
  ggplot(fusel, aes(x = recall, y = precision)) + geom_point() +
    geom_line() + ggtitle(paste0('AUC = ', AUC))
}


p + geom_dotplot(binaxis='y', stackdir='center', dotsize=1)
# violin plot with jittered points
# 0.2 : degree of jitter in x direction
p + geom_jitter(shape=16, position=position_jitter(0.2))


c('3', '5', '10', '30', '50', '100')
ggplot(fusel, aes(x=as.character(coverage), y=precision, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=.2,
                position=position_dodge(.9)) + ylab('mean true recall') + ggtitle('Pacbio2016 mean LongGF precision at coverage at quality levels for 10 replicates each')

ggplot(dd, aes(x=replicate, y=tpos)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  ylab('true positives') + ggtitle('Pacbio2016 LongGF true positives at 100x coverage at 95,100,5 identity for 10 replicates')

ggplot(fuselp, aes(x=as.character(coverage), y=tpos, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
 ylab('mean true recall') + ggtitle('Pacbio2016 mean LongGF true positives at coverage at quality levels for 10 replicates each')

ggplot(fuselp, aes(x = coverage, y = precision, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("LongGF Pacbio2016 precision with coverage and quality levels")

ggplot(fuselp, aes(x = coverage, y = precision, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("LongGF Pacbio2016 varying minsup precision with coverage and quality levels")

ggplot(supab, aes(x = coverage, y = recall, color = tool, group=tool)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("Pacbio2016 recalls with coverage with varioous tools")

ggplot(fuselp, aes(x = coverage, y = recall, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("LongGF Pacbio2016 recall with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = precision, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("LongGF Nanopore2020 varying minsup precision with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = recall, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("Genion Nanopore2020 varying minsup recall with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = precision, color = quality)) +
  geom_line() + ggtitle("Nanopore2020 w/Secondary precision with coverage and quality levels")

ggplot(fuselp, aes(x = coverage, y = recall, color = quality)) +
  geom_line() + ggtitle("Pacbio2016 w/Secondary recall with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = recall, color = quality)) +
  geom_line() + ggtitle("Nanopore2020 w/Secondary recall with coverage and quality levels")

dens <- with(fuselp, tapply(coverage, INDEX = quality, density)) + 
data <- data.frame(
  x = unlist(lapply(dens, "[[", "x")),
  y = unlist(lapply(dens, "[[", "y")),
  cut = rep(names(dens), each = length(dens[[1]]$x)))

fig <- plot_ly(data, x = ~x, y = ~y, z = ~quality, type = 'scatter3d', mode = 'lines', color = ~quality)

fig


fusem <- lapply(c('3', '5', '10', '30', '50', '100'), function(x) {
  long <- lapply(1:10, function(i) {
    tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/fusions/pfun-med/fuse-', x, '-', i,'-sorted_minimap2-splice.log'))
    sw <- startsWith(tab, 'GF')
    ss <- strsplit(tab[sw], ' ')
    ss <- vapply(ss, function(x) x[1], character(1))
    ss <- substring(ss, 4)
    ss <- strsplit(ss, ':')
    ss <- do.call(rbind, ss)
    tab <- data.frame(ss)
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    dup <- duplicated(rbind(valid, tab))
    tab_total <- nrow(tab)
    total <- length(dup)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, coverage = x, type = "experiment", quality = "mediocre", precision = tpos/(fpos + tpos), recall = tpos/(fneg + tpos))
  })
  do.call(rbind, long) %>% group_by(coverage) %>% summarise(mean = mean(tpos), sd = sd(tpos), mean_neg = mean(fpos), sd_neg = sd(fpos), mean_precision = mean(precision), sd_precision = sd(precision), mean_recall = mean(recall), sd_recall = sd(recall), type = "experiment", quality = "mediocre")
})

fuseb <- lapply(c('3', '5', '10', '30', '50', '100'), function(x) {
  long <- lapply(1:10, function(i) {
    tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/fusions/fun-bad/fuse-', x, '-', i,'-sorted_minimap2-splice.log'))
    sw <- startsWith(tab, 'GF')
    ss <- strsplit(tab[sw], ' ')
    ss <- vapply(ss, function(x) x[1], character(1))
    ss <- substring(ss, 4)
    ss <- strsplit(ss, ':')
    ss <- do.call(rbind, ss)
    tab <- data.frame(ss)
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    dup <- duplicated(rbind(valid, tab))
    tab_total <- nrow(tab)
    total <- length(dup)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, coverage = x, type = "experiment", quality = "bad", precision = tpos/(fpos + tpos), recall = tpos/(fneg + tpos))
  })
  do.call(rbind, long) %>% group_by(coverage) %>% summarise(mean = mean(tpos), sd = sd(tpos), mean_neg = mean(fpos), sd_neg = sd(fpos), mean_precision = mean(precision), sd_precision = sd(precision), mean_recall = mean(recall), sd_recall = sd(recall), type = "experiment", quality = "bad")
})

#fuseg <- fuseg %>% group_by(coverage) %>% summarise(mean = mean(tpos))
#fusem <- fusem %>% group_by(coverage) %>% summarise(mean = mean(tpos))
#fuseb <- fuseb %>% group_by(coverage) %>% summarise(mean = mean(tpos))


fuseg <- do.call(rbind, fuseg)
fusem <- do.call(rbind, fusem)
fuseb <- do.call(rbind, fuseb)

df <- rbind(fuseg, fusem, fuseb)

library(ggplot2)
ggplot(df, aes(x=coverage, y=mean, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) + ylab('mean true positives') + ggtitle('Mean found of control transcriptome with LongGF at coverage levels and read quality')


library(ggplot2)
ggplot(df, aes(x=coverage, y=mean_neg, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_neg-sd_neg, ymax=mean_neg+sd_neg), width=.2,
                position=position_dodge(.9)) + ylab('mean false positives') + ggtitle('Mean false positives found in control transcriptome with LongGF at coverage levels and read quality')



library(ggplot2)
ggplot(df, aes(x=coverage, y=mean_recall, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_recall - sd_recall, ymax=mean_recall + sd_recall), width=.2,
                position=position_dodge(.9)) + ylab('mean recall') + ggtitle('Mean recall of control transcriptome using LongGF at coverage levels and read quality')

library(ggplot2)
ggplot(df, aes(x=coverage, y=mean_precision, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_precision - sd_precision, ymax=mean_precision + sd_precision), width=.2,
                position=position_dodge(.9)) + ylab('mean precision') + ggtitle('Mean precision of control transcriptome using LongGF at coverage levels and read quality')



pfusem <- lapply(c('3', '5', '10', '30', '50'), function(x) {
  long <- lapply(1:10, function(i) {
    tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/fusions/pfun-med/fuse-', x, '-', i,'-sorted_minimap2-splice.log'))
    sw <- startsWith(tab, 'GF')
    ss <- strsplit(tab[sw], ' ')
    ss <- vapply(ss, function(x) x[1], character(1))
    ss <- substring(ss, 4)
    ss <- strsplit(ss, ':')
    ss <- do.call(rbind, ss)
    tab <- data.frame(ss)
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    dup <- duplicated(rbind(valid, tab))
    tab_total <- nrow(tab)
    total <- length(dup)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, coverage = x, type = "experiment", quality = "mediocre", precision = tpos/(fpos + tpos), recall = tpos/(fneg + tpos))
  })
  do.call(rbind, long) %>% group_by(coverage) %>% summarise(mean = mean(tpos), sd = sd(tpos), mean_neg = mean(fpos), sd_neg = sd(fpos), mean_precision = mean(precision), sd_precision = sd(precision), mean_recall = mean(recall), sd_recall = sd(recall), type = "experiment", quality = "mediocre", tech = "pacbio2016")
})

pfuseb <- lapply(c('3', '5', '10', '30', '50'), function(x) {
  long <- lapply(1:10, function(i) {
    tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/fusions/pfun-bad/fuse-', x, '-', i,'-sorted_minimap2-splice.log'))
    sw <- startsWith(tab, 'GF')
    ss <- strsplit(tab[sw], ' ')
    ss <- vapply(ss, function(x) x[1], character(1))
    ss <- substring(ss, 4)
    ss <- strsplit(ss, ':')
    ss <- do.call(rbind, ss)
    tab <- data.frame(ss)
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    dup <- duplicated(rbind(valid, tab))
    tab_total <- nrow(tab)
    total <- length(dup)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, coverage = x, type = "experiment", quality = "bad", precision = tpos/(fpos + tpos), recall = tpos/(fneg + tpos))
  })
  do.call(rbind, long) %>% group_by(coverage) %>% summarise(mean = mean(tpos), sd = sd(tpos), mean_neg = mean(fpos), sd_neg = sd(fpos), mean_precision = mean(precision), sd_precision = sd(precision), mean_recall = mean(recall), sd_recall = sd(recall), type = "experiment", quality = "bad", tech = "pacbio2016")
})


nfusem <- lapply(c('3', '5', '10', '30', '50'), function(x) {
  long <- lapply(1:10, function(i) {
    tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/fusions/nfun-med/fuse-', x, '-', i,'-sorted_minimap2-splice.log'))
    sw <- startsWith(tab, 'GF')
    ss <- strsplit(tab[sw], ' ')
    ss <- vapply(ss, function(x) x[1], character(1))
    ss <- substring(ss, 4)
    ss <- strsplit(ss, ':')
    ss <- do.call(rbind, ss)
    tab <- data.frame(ss)
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    dup <- duplicated(rbind(valid, tab))
    tab_total <- nrow(tab)
    total <- length(dup)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, coverage = x, type = "experiment", quality = "mediocre", precision = tpos/(fpos + tpos), recall = tpos/(fneg + tpos))
  })
  do.call(rbind, long) %>% group_by(coverage) %>% summarise(mean = mean(tpos), sd = sd(tpos), mean_neg = mean(fpos), sd_neg = sd(fpos), mean_precision = mean(precision), sd_precision = sd(precision), mean_recall = mean(recall), sd_recall = sd(recall), type = "experiment", quality = "mediocre", tech = "nanopore2020")
})

nfuseb <- lapply(c('3', '5', '10', '30', '50'), function(x) {
  long <- lapply(1:10, function(i) {
    tab <- readLines(con=paste0('/home/vantwisk/vantwisk/fusions/fusions/nfun-bad/fuse-', x, '-', i,'-sorted_minimap2-splice.log'))
    sw <- startsWith(tab, 'GF')
    ss <- strsplit(tab[sw], ' ')
    ss <- vapply(ss, function(x) x[1], character(1))
    ss <- substring(ss, 4)
    ss <- strsplit(ss, ':')
    ss <- do.call(rbind, ss)
    tab <- data.frame(ss)
    colnames(tab) <- c('V1', 'V2')
    ll <- as.character(unlist(tab))
    valid2 <- valid
    valid2['pass1'] <- ifelse(valid2[,1] %in% ll, 1, 0)
    valid2['pass2'] <- ifelse(valid2[,2] %in% ll, 1, 0)
    valid2['total'] <- ifelse(valid2['pass1'] + valid2['pass2'] > 0, 1, 0)
    dup <- duplicated(rbind(valid, tab))
    tab_total <- nrow(tab)
    total <- length(dup)
    tpos <- sum(valid2["total"])
    fneg <- nrow(valid) - tpos
    fpos <- nrow(tab) - tpos
    fpos <- ifelse(fpos < 0, 0, fpos)
    data.frame(tpos = tpos, fpos=fpos, fneg=fneg, coverage = x, type = "experiment", quality = "bad", precision = tpos/(fpos + tpos), recall = tpos/(fneg + tpos))
  })
  do.call(rbind, long) %>% group_by(coverage) %>% summarise(mean = mean(tpos), sd = sd(tpos), mean_neg = mean(fpos), sd_neg = sd(fpos), mean_precision = mean(precision), sd_precision = sd(precision), mean_recall = mean(recall), sd_recall = sd(recall), type = "experiment", quality = "bad", tech = "nanopore2020")
})

#pfuseg <- do.call(rbind, pfuseg)
pfusem <- do.call(rbind, pfusem)
pfuseb <- do.call(rbind, pfuseb)

pdf <- rbind(pfusem, pfuseb)

#nfuseg <- do.call(rbind, nfuseg)
nfusem <- do.call(rbind, nfusem)
nfuseb <- do.call(rbind, nfuseb)

ndf <- rbind(nfusem, nfuseb)

tdf <- rbind(pdf, ndf)

mdf <- rbind(nfusem, pfusem)
bdf <- rbind(nfuseb, pfuseb)

library(ggplot2)
ggplot(pdf, aes(x=coverage, y=mean_neg, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  #geom_errorbar(aes(ymin=mean_neg-sd_neg, ymax=mean_neg+sd_neg), width=.2,
              #  position=position_dodge(.9))
  ylab('mean false positives') + ggtitle('Pacbio2016 Mean found of control transcriptome with LongGF at coverage levels and read quality')

library(ggplot2)
ggplot(pdf, aes(x=coverage, y=mean_recall, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_recall - sd_recall, ymax=mean_recall + sd_recall), width=.2,
                position=position_dodge(.9)) + ylab('mean recall') + ggtitle('Pacbio2016 Mean recall of control transcriptome using LongGF at coverage levels and read quality')

library(ggplot2)
ggplot(pdf, aes(x=coverage, y=mean_precision, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_precision - sd_precision, ymax=mean_precision + sd_precision), width=.2,
                position=position_dodge(.9)) + ylab('mean precision') + ggtitle('Pacbio2016 Mean precision of control transcriptome using LongGF at coverage levels and read quality')


library(ggplot2)
ggplot(ndf, aes(x=coverage, y=mean_neg, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
 # geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
 #               position=position_dodge(.9))
  ylab('mean false positives') + ggtitle('Nanopore2020 Mean found of control transcriptome with LongGF at coverage levels and read quality')

library(ggplot2)
ggplot(ndf, aes(x=coverage, y=mean_recall, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_recall - sd_recall, ymax=mean_recall + sd_recall), width=.2,
                position=position_dodge(.9)) + ylab('mean recall') + ggtitle('Nanopore2020 Mean recall of control transcriptome using LongGF at coverage levels and read quality')

library(ggplot2)
ggplot(ndf, aes(x=coverage, y=mean_precision, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_precision - sd_precision, ymax=mean_precision + sd_precision), width=.2,
                position=position_dodge(.9)) + ylab('mean precision') + ggtitle('Nanopore2020 Mean precision of control transcriptome using LongGF at coverage levels and read quality')








library(ggplot2)
ggplot(mdf, aes(x=coverage, y=mean, fill=tech)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) + ylab('mean true positives') + ggtitle('Mediocre Pacbio2016 vs Nanopore2020 Mean found of control transcriptome with LongGF at coverage levels')

library(ggplot2)
ggplot(mdf, aes(x=coverage, y=mean_recall, fill=tech)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_recall - sd_recall, ymax=mean_recall + sd_recall), width=.2,
                position=position_dodge(.9)) + ylab('mean recall') + ggtitle('Mediocre Pacbio2016 vs Nanopore2020  Mean recall of control transcriptome using LongGF at coverage levels')

library(ggplot2)
ggplot(mdf, aes(x=coverage, y=mean_precision, fill=tech)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_precision - sd_precision, ymax=mean_precision + sd_precision), width=.2,
                position=position_dodge(.9)) + ylab('mean precision') + ggtitle('Medicore Pacbio2016 vs Nanopore2020  Mean precision of control transcriptome using LongGF at coverage levels')



library(ggplot2)
ggplot(bdf, aes(x=coverage, y=mean, fill=tech)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) + ylab('mean true positives') + ggtitle('Bad Pacbio2016 vs Nanopore2020 Mean found of control transcriptome with LongGF at coverage levels')

library(ggplot2)
ggplot(bdf, aes(x=coverage, y=mean_recall, fill=tech)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_recall - sd_recall, ymax=mean_recall + sd_recall), width=.2,
                position=position_dodge(.9)) + ylab('mean recall') + ggtitle('Bad Pacbio2016 vs Nanopore2020  Mean recall of control transcriptome using LongGF at coverage levels')

library(ggplot2)
ggplot(bdf, aes(x=coverage, y=mean_precision, fill=tech)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean_precision - sd_precision, ymax=mean_precision + sd_precision), width=.2,
                position=position_dodge(.9)) + ylab('mean precision') + ggtitle('Bad Pacbio2016 vs Nanopore2020  Mean precision of control transcriptome using LongGF at coverage levels')


fasta <- readDNAStringSet('Homo_sapiens.cdna_50k.fusion_transcripts_3.fasta')
fan <- names(fasta)
fan <- strsplit(fan, ' ')
oner <- vapply(fan, function(x) x[[2]], character(1))
twor <- vapply(fan, function(x) x[[3]], character(1))

ss1 <- select(txdb,keys=oner,keytype = "TXNAME", columns = c("TXSTRAND", "TXTYPE", "TXNAME"))
ss2 <- select(txdb,keys=twor,keytype = "TXNAME", columns = c("TXSTRAND", "TXTYPE", "TXNAME"))


