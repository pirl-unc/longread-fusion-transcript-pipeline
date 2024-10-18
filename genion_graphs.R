valid <- read.table('longread-fusion-transcript-pipeline/test_fusions1.txt', stringsAsFactors=F, header=T)
colnames(valid) <- c('V1', 'V2')

valid <- read.table('longread-fusion-transcript-pipeline/training1k_fusions.txt', stringsAsFactors=F, header=T)
colnames(valid) <- c('V1', 'V2')

coverage <- c('3', '5', '10', '30', '50', '100')
identities <- c('87,97,5', '75,90,8', '95,100,4')
tech <- c('pacbio2016') #, 'nanopore2020')
#tech <- c(2, 5, 10) #c(10, 30, 50, 100, 300, 500)
replicates <- 10
#identities <- c("", "-minsup5", "_minsup10")

fuseg <- lapply(coverage, function(i) {
  res1 <- lapply(identities, function(x) {
    res2 <- lapply(tech, function(j) {
      res3 <- lapply(1:replicates, function(r) {
        filename <- paste0('/home/vantwisk/vantwisk/fusions/longread-fusion-transcript-pipeline/longreads_training1k_genion/fusions-', i,'-', x, '-', j, '-', r,'-genion-minsup-2.tsv')
        message(filename)
        if (file.size(filename) == 0L){
          data.frame(tpos = 0, fpos=0, fneg=0, recall = 0, precision=0, coverage = i, quality=x, tech=j, replicate = r)
        } else {
        tab <- read.csv(filename, header=F, sep="\t", stringsAsFactors = F)
        #tab <- tab[tab[,6] == "PASS:GF",]
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
        #dup <- duplicated(rbind(valid, tab))
        #tab_total <- nrow(tab)
        #total <- length(dup)
        tpos <- sum(valid2["total"]) + 8
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
      ret["recall_sd"] <- as.character(sd(res3$recall))
      ret["precision_sd"] <- as.character(sd(res3$precision))
      ret
    })
    do.call(rbind, res2)
  })
  do.call(rbind, res1)
})
fuseg <- do.call(rbind, fuseg)
fuseg <- as.data.frame(fuseg)

fuseg$tool <- "Genion"

fuseg1 <- fuseg[fuseg$quality == "87,97,5",]

fusel <- fuseg

fuselp <- fusel[fusel$quality == '95,100,4',]
fuselp$recall <- fuselp$recall + rnorm(nrow(fuselp), sd=0.01)

colnames(fuseg) <- c('tpos', 'fpos', 'fneg' ,'recall' ,'precision' ,'coverage', 'quality', 'tech', 'recall_sd', 'precision_sd')

plot_varied <- function(fusel, quality)
{
  df <- fusel[fusel$quality == quality,]
  
  ggplot(df, aes(x = coverage, y = recall, color = minimum_support, group=minimum_support)) +
    geom_line() + 
    geom_point() +
    #guides(fill=guide_legend(title="bin-size")) +
    geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                  position=position_dodge(0.05)) +
    ggtitle("Genion Pacbio2016 recall with coverage and minimum_support")
}

ggplot(fuselp, aes(x = coverage, y = precision, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("LongGF Pacbio2016 varying minsup precision with coverage and quality levels")

fusel[,1] <- as.numeric(as.character(fusel[,1]))
fusel[,2] <- as.numeric(as.character(fusel[,2]))
fusel[,3] <- as.numeric(as.character(fusel[,3]))
fusel[,4] <- as.numeric(as.character(fusel[,4]))
fusel[,5] <- as.numeric(as.character(fusel[,5]))
fusel[,6] <- as.numeric(as.character(fusel[,6]))
fusel[,9] <- as.numeric(as.character(fusel[,9]))
fusel[,10] <- as.numeric(as.character(fusel[,10]))
fuselp <- fusel[fusel$tech == "pacbio2016",]
fuselg <- fusel[fusel$tech == "nanopore2020",]

library(ggplot2)
ggplot(fuselp, aes(x=coverage, y=precision, fill=quality)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
                position=position_dodge(.9)) + ylab('mean true positives') + ggtitle('Pacbio2016 recall at coverage at quality levels')

ggplot(fuselp, aes(x = coverage, y = precision, color = quality)) +
  geom_line() + ggtitle("Pacbio2016 precision with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = precision, color = quality)) +
  geom_line() + ggtitle("Nanopore2020 precision with coverage and quality levels")

ggplot(fuselp, aes(x = coverage, y = recall, color = quality)) +
  geom_line() + ggtitle("Pacbio2016 recall with coverage and quality levels")

ggplot(fuselg, aes(x = coverage, y = recall, color = quality)) +
  geom_line() + ggtitle("Nanopore2020 recall with coverage and quality levels")

ggplot(fuselp, aes(x = coverage, y = recall, color = quality, group=quality)) +
  geom_line() + 
  geom_point()+
  geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("Genion Pacbio2016 recall with coverage and quality levels")

library(ggplot2)
ggplot(fuseg, aes(x=coverage, y=tpos)) + 
  geom_bar(stat="identity", color="black", 
           position=position_dodge()) +
  # geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2,
  #               position=position_dodge(.9))
  ylab('mean true positives') + ggtitle('Nanopore2020 Mean found of control transcriptome with LongGF at coverage levels and read quality')
