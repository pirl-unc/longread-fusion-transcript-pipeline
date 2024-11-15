library(gridExtra)
library(dplyr)
library(GenomicRanges)
library(ggplot2)
library(ggVennDiagram)
library("ORFik")
library(Biostrings)
library(ShortRead)

tab <- readLines(con='/datastore/scratch/users/vantwisk/bbn963/bbn963_pacbio_time-minsup1-longgf2.log')
ll <- gregexpr("m\\d+_\\d+_\\d+_s1/\\d+/[A-Za-z]+/\\d+_\\d+", tab)
evs <- regmatches(tab, ll)
evs <- unlist(evs[lengths(evs) > 0])
sw <- startsWith(tab, 'GF')
ss1 <- strsplit(tab[sw], ' ')
nevs <- vapply(ss1, function(x) {as.numeric(x[2])}, numeric(1))
ss <- vapply(ss1, function(x) x[1], character(1))
ss <- substring(ss, 4)
ss <- strsplit(ss, ':')
ss <- do.call(rbind, ss)
ss <- as.data.frame(ss)
ss$spanning_reads <- as.character(vapply(ss1, function(x) x[2], character(1)))
colnames(ss) <- c("V1", "V2", "spanning_reads")
genes <- paste0(ss[,1], ':', ss[,2])
genes <- rep(genes, times=nevs)
genes <- split(evs, genes, lex.order)
genep <- vapply(genes, function(x) {paste(x, collapse=",")}, character(1))
ss$longgf_evidences <- genep

longgf <- ss

browser()

#end1 <- paste0('chr', vapply(ss1, function(x) x[3], character(1)))
#end2 <- paste0('chr', vapply(ss1, function(x) x[4], character(1)))

#seqnameo <- paste0('chr', 1:20)
#seqnameo <- c(seqnameo, 'chrY', 'chrX')

#longgf_starts <- GRanges(seqinfo = seqnameo, end1)
#longgf_ends <- GRanges(seqinfo = seqnameo, end2)

#longgf_genes <- lapply(ss1, function(x) {unlist(strsplit(strsplit(x[1], '\t')[[1]][2], ':'))})
#longgf_df <- do.call(rbind, longgf_genes)

#bed <- read.table("bbn963_pbfusion_again2.breakpoints.groups.bed",header = FALSE, sep="\t",stringsAsFactors=FALSE, quote="")
#chrom1 <- bed[,1]
#chrom1 <- gsub("^.{0,3}", "", chrom1)
#chrom2 <- bed[,4]
#chrom2 <- gsub("^.{0,3}", "", chrom2)

#bp_genes <- lapply(bed[,11], function(x) {
#	unlist(strsplit(strsplit(strsplit(x, ';')[[1]][3],"=")[[1]][2], ','))
#})
#pbfusion_df <- do.call(rbind, bp_genes)

#pb_starts <- paste0(chrom1, ':', bed[,2])
#pb_ends <- paste0(chrom2, ':', bed[,5])

#pbfusion_starts <- GRanges(seqinfo=seqnameo, pb_starts)
#pbfusion_ends <- GRanges(seqinfo=seqnameo, pb_ends)

tab <- read.csv('/datastore/scratch/users/vantwisk/bbn963/jaffal_out_pacbio/jaffa_results.csv', header=T)
#tab <- tab[tab$spanning.reads > 2,]
sp <- tab$spanning.reads
ss <- unique(tab$fusion.genes)
ss <- strsplit(ss, ':')
tab <- do.call(rbind, ss)
tab <- as.data.frame(tab)
tab$spanning_reads <- sp

jaffal <- tab

#tabj <- read.csv('jaffa_results_bbn963.csv', header=T)
#chrom1 <- tab['chrom1'][,1]
#chrom1 <- gsub("^.{0,3}", "", chrom1)
#chrom2 <- tab['chrom2'][,1]
#chrom2 <- gsub("^.{0,3}", "", chrom2)
#base1 <- tab$base1
#base2 <- tab$base2

#jaffa_fix <- chrom2 %in% seqnameo

#chrom1 <- chrom1[jaffa_fix]
#base1 <- base1[jaffa_fix]
#chrom2 <- chrom2[jaffa_fix]
#base2 <- base2[jaffa_fix]

#jaffal_starts <- GRanges(seqinfo = seqnameo, chrom1, base1)
#jaffal_ends <- GRanges(seqinfo = seqnameo, chrom2, base2)

tab <- read.table("/datastore/scratch/users/vantwisk/bbn963/bbn963_pacbio_time-sorted-minsup1-fusionseeker/confident_genefusion.txt", sep="\t")
ss1 <- tab[,1]
ss2 <- tab[,2]
tab <- data.frame(V1=ss1, V2=ss2, spanning_reads=as.character(tab[,3]), evidence=tab[,9])

fusionseeker <- tab

ifl <- generics::intersect(fusionseeker[,c(1, 2)], longgf[,c(1, 2)])
ifj <- generics::intersect(fusionseeker[,c(1, 2)], jaffal[,c(1, 2)])
ilj <- generics::intersect(longgf[,c(1, 2)], jaffal[,c(1, 2)])


test <- merge(fusionseeker, longgf, by.x=c('V1', 'V2'),by.y=c('V1', 'V2'), all=T)
test2 <- merge(test, jaffal, by.x=c('V1', 'V2'),by.y=c('V1', 'V2'), all=T)
test2[is.na(test2)] <- 0

testex <- merge(fusionseeker, longgf, by.x=c('V1', 'V2'),by.y=c('V1', 'V2'))
testex2 <- merge(testex, jaffal, by.x=c('V1', 'V2'),by.y=c('V1', 'V2'))
testex2[is.na(testex2)] <- 0
testex2 <- testex2[,-c(4)]

cnames <- c('Gene1', 'Gene2', 'Fusionseeker', 'LongGF', 'JAFFAL')
colnames(testex2) <- cnames


rs <- rowSums(test2[,c(3,5,6)] > 0)
final <- test2[rs>1,]
final[,3] <- as.numeric(final[,3])
final[,5] <- as.numeric(final[,5])
final[,6] <- as.numeric(final[,6])
final2 <- final[order(rowSums(final[,c(3,5,6)]), decreasing=T),]
final2 <- final2[final2[,3] > 0,]
final3 <- final2[,-c(4)]
comb_names <- paste0(final2[,1], ':', final2[,2])
stsp <- strsplit(final2$evidence, ",")
groupings <- rep(comb_names, times=lengths(stsp))

final2$cgenes <- comb_names

colnames(final3) <- cnames

evs <- vapply(stsp, function(x){x[1]}, character(1))

evs_all <- unlist(stsp)

write.table(evs, "in.tbl")
write.table(evs_all, "in_all.tbl", col.names=F, row.names=F, quote=F)

fq <- readFastq("out.fq")
fqs <- sread(fq)
names(fqs) <- paste0(paste0(final2[,1], ':', final2[,2]), seq_along(fqs))
#orfs <- lapply(fqs, function(x) {findORFs(x)})
orfs <- findORFs(fqs)
gr <- unlist(orfs, use.names = TRUE)
gr <- GRanges(seqnames = names(fqs)[as.integer(names(gr))], ranges(gr), strand = "+")
names(gr) <- paste0("ORF_", seq.int(length(gr)), "_", seqnames(gr))
orf_seqs <- getSeq(fqs, gr)

ss <- strsplit(names(orf_seqs), '_')
ss <- vapply(ss, function(x) {x[[3]]}, character(1))

peptide_seqs <- translate(orf_seqs)

writeXStringSet(peptide_seqs, "peptides_fragments.fa")

aa <- split(peptide_seqs, ss)
aw <- lapply(aa, function(a) {
    w <- which.max(width(a))
    a[w]
})

aas <- AAStringSetList(aw)
aas <- unlist(aas)
writeXStringSet(aas, "peptides_fragments_longest.fa")

fq <- readFastq("out_all.fq")
fqs <- sread(fq)

names(fqs) <- paste0(paste0(groupings,'_', seq_along(fqs)))
#orfs <- lapply(fqs, function(x) {findORFs(x)})
orfs <- findORFs(fqs)
gr <- unlist(orfs, use.names = TRUE)
gr <- GRanges(seqnames = names(fqs)[as.integer(names(gr))], ranges(gr), strand = "+")
names(gr) <- paste0("ORF_", seq.int(length(gr)), "_", seqnames(gr))
orf_seqs <- getSeq(fqs, gr)

ss <- strsplit(names(orf_seqs), '_')
ss <- vapply(ss, function(x) {x[[3]]}, character(1))

peptide_seqs <- translate(orf_seqs)
pg <- split(peptide_seqs, ss)

browser()

writeXStringSet(peptide_seqs, "peptides_fragments.fa")


fg <- paste(fusionseeker[,1], fusionseeker[,2])
lg <- paste(longgf[,1], longgf[,2])
jg <- paste(jaffal[,1], jaffal[,2])

x <- list(FusionSeeker=fg, LongGF=lg, JAFFAL=jg)

gg <- ggVennDiagram(x) + theme(legend.position="none")
ggsave("mouse_fusions_venn.png", gg)



png(filename="fusion_intersect.png")
grid.table(testex2)
dev.off()

png(filename="fusion_all_2.png")
grid.table(final3)
dev.off()
