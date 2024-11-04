if (!require("BiocManager", quietly = TRUE))
	    install.packages("BiocManager", repo='https://archive.linux.duke.edu/cran/')
if (!require("GenomicFeatures", quietly = TRUE))
	    BiocManager::install("GenomicFeatures")
if (!require("Biostrings", quietly = TRUE))
	    BiocManager::install("Biostrings")
if (!require("rtracklater", quietly = TRUE))
	    BiocManager::install("rtracklayer")
if (!require("biomaRt", quietly = TRUE))
	    BiocManager::install("biomaRt")


library(GenomicFeatures)
library(Biostrings)
library(biomaRt)
library(rtracklayer)


arg <- commandArgs(trailingOnly=TRUE)

#arg[2] <- '/home/vantwisk/vantwisk/fusions/seq_run4/ref/Homo_sapiens.GRCh38.cdna.all.fa'
#arg[1] <- '/home/vantwisk/vantwisk/fusions/seq_run4/ref/Homo_sapiens.GRCh38.105.gtf'
#arg[3] <- '/home/vantwisk/vantwisk/fusions/seq_run2/ref/Homo_sapiens_transcriptome_limited_1000_test.fa'
#arg[4] <- 1000

#arg[1] <- '/home/vantwisk/vantwisk/fusions/seq_run4/ref/gencode.v38.annotation.gtf'
#arg[2] <- '/home/vantwisk/vantwisk/fusions/seq_run4/ref/gencode.v38.transcripts.fa'
#arg[3] <- '/home/vantwisk/vantwisk/fusions/seq_run4/ref/Homo_sapiens_transcriptome_limited_1000_test.fa'
#arg[4] <- 1000

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

if (!is.null(ele$transcript_version)) {
  ele['full_tx'] <- paste0(ele$transcript_id, '.', ele$transcript_version)
} else {
  ele['full_tx'] <- ele$transcript_id
}

nam <- names(fa)
if (length(strsplit(nam[1], "\\|")[[1]]) > 3) {
  nam <- strsplit(nam, "\\|")
} else {
  nam <- strsplit(nam, ' ')
}

tx_act <- vapply(nam, function(x) x[1], character(1))

wh1 <- which(tx_act %in% ele$full_tx)
fa1 <- fa[wh1]
fa1 <- fa1[lengths(fa1) > 100]

if (length(strsplit(names(fa1)[1], "\\|")[[1]]) > 3) {
  tx_act <- vapply(strsplit(names(fa1), "\\|"), function(x) x[1], character(1))
} else {
   tx_act <- vapply(strsplit(names(fa1), ' '), function(x) x[1], character(1))
}

mart <- useEnsembl("ensembl",dataset="hsapiens_gene_ensembl")
## get everything
BM.info <- getBM(attributes=c("ensembl_gene_id","ensembl_transcript_id_version","hgnc_symbol","transcript_is_canonical"),mart=mart)

## canonical transcripts
BM.info.canon <- subset(BM.info,transcript_is_canonical == 1)
canonical <- BM.info.canon$ensembl_transcript_id

#fa1 <- sample(fa1, arg[4], replace=F)
fa1 <- fa1[tx_act %in% canonical]

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
