library(GenomicFeatures)
library(Biostrings)

arg <- commandArgs(trailingOnly=TRUE)

fa <- readDNAStringSet(arg[2])
#fa <- Biostrings::readDNAStringSet('longread-fusion-transcript-pipeline/Homo_sapiens.GRCh38.cdna.all.fa')

#txdb <- makeTxDbFromGFF('longread-fusion-transcript-pipeline/Homo_sapiens.GRCh38.105.gtf')

gtf <- rtracklayer::import(arg[1])

fasta_out <- arg[3]

ele <- elementMetadata(gtf)
ele <- ele[ele$type == 'transcript',]

ele['full_tx'] <- paste0(ele$transcript_id, '.', ele$transcript_version)

nam <- names(fa)
nam <- strsplit(nam, ' ')

tx1 <- vapply(nam, function(x) x[2], character(1))
tx2 <- vapply(nam, function(x) x[3], character(1))

tx_act <- vapply(nam, function(x) x[1], character(1))

vals1 <- ele[ele$full_tx %in% tx1,]

wh1 <- which(tx_act %in% ele$full_tx)
writeXStringSet(fa[wh1], fasta_out)
#gtf1 <- gtf[wh1,]

#fa1 <- fa[wh1]
#nam1 <- names(fa1)
#nam1 <- strsplit(nam1, ' ')

#txer <- vapply(nam1, function(x) x[2], character(1))

#wh1 <- which(ele$full_tx %in% tx1)
#gtf1 <- gtf[wh1,]

#wh2 <- which(ele$full_tx %in% tx2)
#gtf2 <- gtf[wh2,]
