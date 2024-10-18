valid <- read.table('training1k_fusions.txt', stringsAsFactors=F, header=T)
colnames(valid) <- c('V1', 'V2')

coverage <- c('5', '10', '30', '50', '100')
identities <- c( '75,90,8', '87,97,5', '95,100,4')
tech <- c('pacbio2016') # 'nanopore2020')
replicates <- 10
#identities <- c(0, 5, 10)

fusej <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
        filename <- paste0('/home/vantwisk/vantwisk/fusions/longread-fusion-transcript-pipeline/longreads1k_training_jaffal/fusions-', i,'-', x, '-', j,'-', 1,'-jaffal_out/jaffa_results.csv')
        message(filename)
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
#    dup <- duplicated(rbind(valid, tab))
#    tab_total <- nrow(tab)
#    total <- length(dup)
    tpos <- sum(valid2["total"]) + 6
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
fusej <- fusej[fusej$tech == "pacbio2016",]

fusej$tool <- "JAFFAL"

fusej1 <- fusej[fusej$quality == "87,97,5",]

fusel[,7] <- as.character(fusel[,7])

fuselp <- fusej[fusej$tech == "pacbio2016",]
fuselg <- fusel[fusel$tech == "nanopore2020",]



ggplot(fuselp, aes(x = coverage, y = precision, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  ggtitle("JAFFAL Pacbio2016 varying spanning reads precision with coverage and quality levels")

ggplot(fuselp, aes(x = coverage, y = recall, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  ggtitle("JAFFAL Pacbio2016 recall spanning reads with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = precision, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  ggtitle("JAFFAL Nanopore2020 precision spanning reads with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = recall, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  ggtitle("JAFFAL Nanopore2020 recall spanning reads with coverage and quality levels")

fuselp$coverage <- as.numeric(fuselp$coverage)
ggplot(fuselp, aes(x = coverage, y = recall, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("JAFFAL Pacbio2016 recall with coverage and quality levels")

library(ggplot2)
ggplot(ndf, aes(x=coverage, y=tpos)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  # geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
  #               position=position_dodge(.9))
  ylab('mean true positives') + ggtitle('Nanopore2020 Mean found of control transcriptome with LongGF at coverage levels and read quality')
