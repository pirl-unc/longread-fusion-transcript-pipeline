if (!require("BiocManager", quietly = TRUE))
	    install.packages("BiocManager", repo='https://archive.linux.duke.edu/cran/')
if (!require("GenomicFeatures", quietly = TRUE))
	    BiocManager::install("GenomicFeatures")
if (!require("Biostrings", quietly = TRUE))
	    BiocManager::install("Biostrings")

library(GenomicFeatures)
library(Biostrings)

arg <- commandArgs(trailingOnly=TRUE)

arg[1] <- '/home/vantwisk/vantwisk/fusions/seq_run2/ref/gencode.v38.annotation.gtf'
arg[2] <- '/home/vantwisk/vantwisk/fusions/seq_run2/ref/gencode.v38.transcripts.fa'
arg[3] <- '/home/vantwisk/vantwisk/fusions/seq_run2/ref/Homo_sapiens_transcriptome_limited_1000.fa'
arg[4] <- 1000

message(arg[1])
message(arg[2])
message(arg[3])
message(arg[4])

#fa <- readDNAStringSet(arg[2])
fa <- Biostrings::readDNAStringSet(arg[2])

#txdb <- makeTxDbFromGFF('longread-fusion-transcript-pipeline/Homo_sapiens.GRCh38.105.gtf')

gtf <- rtracklayer::import(arg[1])
#gtf <- import(arg[1])

fasta_out <- arg[3]
#fasta_out <- arg[3]

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
fa1 <- fa[wh1]
fa1 <- fa1[lengths(fa1) > 100]

fa1 <- sample(fa1, arg[4], replace=F)

writeXStringSet(fa1, fasta_out)
#gtf1 <- gtf[wh1,]

#fa1 <- fa[wh1]
#nam1 <- names(fa1)
#nam1 <- strsplit(nam1, ' ')

#txer <- vapply(nam1, function(x) x[2], character(1))

#wh1 <- which(ele$full_tx %in% tx1)
#gtf1 <- gtf[wh1,]

#wh2 <- which(ele$full_tx %in% tx2)
#gtf2 <- gtf[wh2,]
