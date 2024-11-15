library('stringr')

arg <- commandArgs(trailingOnly=TRUE)

fusim <- read.table(arg[1], sep="\t", header=T)

fusions <- fusim[,2]

fusions <- as.data.frame(matrix(fusions, ncol=2, byrow=T))

write.table(fusions, arg[2], sep="\t", row.names=F, col.names=T, quote=F)
