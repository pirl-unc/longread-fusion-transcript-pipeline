coverage <- c('3', '5', '10', '30', '50', '100')
replicates <- 10
leng <- c('100', '150')
#identities <- c(0, 5, 10)

fusea <- lapply(coverage, function(i) {
  res1 <- lapply(leng, function(x) {
    res3 <- lapply(1:replicates, function(r) {
      filename <- paste0('/home/vantwisk/vantwisk/fusions/longread-fusion-transcript-pipeline/shortreads_training2k_arriba/fusions-', i, '-', x, '-', r,'.tsv')
      message(filename)
      tab <- read.table(filename)
      tab <- tab[,c(1,2)]
      #tab <- strsplit(tab, '--')
      #tab <- lapply(tab, function(x) {
      #  data.frame(V1=as.character(x[1]), V2=as.character(x[2]))
      #})
      #tab <- do.call(rbind, tab)
      
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
    ret["coverage"] <- as.numeric(res3[1,"coverage"])
    ret["read_length"] <- as.numeric(res3[1,"read_length"])
    #ret["tech"] <- as.character(res3[1,"tech"])
    ret["recall_sd"] <- as.character(sd(res3$recall))
    ret["precision_sd"] <- as.character(sd(res3$precision))
    ret
    #res3
  })
  ret <- do.call(rbind, res1)
  ret
  #res1
})
fusea2k <- as.data.frame(do.call(rbind, fusea))
fusea

fusea100 <- fusea[fusea$read_length == 100,]
fusea100$tool <- "Arriba-read_length-100"
fusea1001

fusea150 <- fusea[fusea$read_length == 150,]
fusea150$tool <- "Arriba-read_length-150"
fusea1501

get_df <- function(one, two, three, four, five){
  elements <- c('tpos', 'fpos', 'fneg', 'recall', 'precision', 'coverage', 'recall_sd', 'precision_sd', 'tool')
  one1 <- one[,elements]
  two1 <- two[,elements]
  three1 <- three[,elements]
  four1 <- four[,elements]
  five1 <- five[,elements]
  do.call(rbind, list(one1, two1, three1, four1, five1))
}

df$coverage <- as.numeric(df$coverage)
df$recall <- as.numeric(df$recall)
df$precision <- as.numeric(df$precision)
df$recall_sd <- as.numeric(df$recall_sd)
df$precision_sd <- as.numeric(df$precision_sd)

ggplot(df, aes(x = coverage, y = recall, color = tool, group=tool)) +
  geom_line() + 
  geom_point() +
  geom_errorbar(aes(ymin=recall-recall_sd, ymax=recall+recall_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("Longread and Short read tools coverage and recall")

df$coverage <- as.numeric(df$coverage)
df$recall <- as.numeric(df$recall)
df$precision <- as.numeric(df$precision)
df$recall_sd <- as.numeric(df$recall_sd)
df$precision_sd <- as.numeric(df$precision_sd)

df[12, c(5, 8)] <- c(1, 0)

ggplot(df, aes(x = coverage, y = precision, color = tool, group=tool)) +
  geom_line() + 
  geom_point() +
  geom_errorbar(aes(ymin=precision-precision_sd, ymax=precision+precision_sd), width=2,
                position=position_dodge(0.05)) +
  ggtitle("Longread and Short read tools coverage and precision")
