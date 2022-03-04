
library(Biostrings)
library(ggplot2)
library(GenomicFeatures)
library(TxDb.Hsapiens.UCSC.hg38.knownGene)

graph_dir <- 'graph'

fasta <- readDNAStringSet('Homo_sapiens.cdna_50k.fa')

end_dna_file <- 'Homo_sapiens.cdna_50k.fusion_transcripts_3.fasta'

abundance_file <- '/home/vantwisk/nanosim/pre-trained_models/human_NA12878_cDNA_Bham1_guppy/expression_abundance.tsv'

end_dir_file <- '/home/vantwisk/nanosim/pre-trained_models/human_NA12878_cDNA_Bham1_guppy/expression_abundance_fusions3.tsv'

end_gene_file <- 'hs_fusion3.txt'

mm <- names(fasta)
ss <- strsplit(mm, ' ')
ll <- unname(lapply(ss, function(x) x[1]))

split_fusion <- function(){
    adu <- read.table(abundance_file, stringsAsFactors=F, sep="\t", header=T, row.names=NULL)
    adu <- adu[order(adu[,3], decreasing=T),]
    adu <- adu[adu[,3] > 10,]
    bib <- lapply(1:2500, function(x) {
	wh1 <- numeric()
	wh2 <- numeric()
	while(length(wh1) == 0 || length(wh2) == 0){
            one <- sample(1:nrow(adu), 1)
            two <- sample(1:nrow(adu), 1)
	    while(one == two) {two <- sample(1:nrow(abu), 1)}
            first <- adu[one,1]
            second <- adu[two,1]
            wh1 <- which(ll %in% first)
            wh2 <- which(ll %in% second)
	}
        dna1 <- fasta[[wh1]]
        dna2 <- fasta[[wh2]]
        s1 <- subseq(dna1, 1, floor(width(fasta[wh1])/2))
        s2 <- subseq(dna2, floor(width(fasta[wh2])/2), width(fasta[wh2]))
        s3 <- c(s1, s2)
        s3 <- DNAStringSet(s3)
        tname <- paste0('ENSTF', x)
        gname1 <- strsplit(strsplit(names(fasta[wh1]), ' ')[[1]][[7]], ':')[[1]][2]
        gname2 <- strsplit(strsplit(names(fasta[wh2]), ' ')[[1]][[7]], ':')[[1]][2]
        names(s3) <- paste0(tname, ' ', first, ' ', second, ' ', gname1, ' ', gname2)
        df2 <- data.frame(one = gname1, two = gname2)

        first <- adu[one,]
        second <- adu[two,]
        est_counts <- (first[,2]/2) + (second[,2]/2)
        tpm <- (first[,3]/2) + (second[,3]/2)
        df <- data.frame(target_id = tname, est_counts = est_counts, tpm = tpm)
        list(s3, df, df2, list(s1, s2), list(lengths(s1), lengths(s2)))
    })
    dnas <- lapply(bib, function(x) x[[1]])
    fours <- lapply(bib, function(x) x[[4]])
    dnas <- do.call(c, dnas)
    writeXStringSet(dnas, end_dna_file)
    
    val <- lapply(bib, function(x){
      ss <- sum(str_count(as.character(x[[1]]), c("G", "C")))
      ll <- lengths(x[[1]])
      ss/ll
    })
    val_df <- data.frame(gc =unlist(val))
    ggplot(val_df, aes(x = gc)) +
      geom_histogram(aes(y = ..density..), 
                     binwidth = 0.01, colour = "blue", fill = "white")+
      geom_density()

    

    len <- data.frame(length = lengths(dnas))
    png(file=paste0(graph_dir, 'transcript_lengths.png'))
    ggplot(len, aes(x = length)) +
    geom_histogram(aes(y = ..density..), 
                   binwidth = 100, colour = "blue", fill = "white")+
       geom_density() + xlim(0, 10000)
    dev.off()

    dfs <- lapply(bib, function(x) x[[2]])
    dfs <- do.call(rbind, dfs)
    write.table(dfs, end_dir_file, sep="\t", quote=F, row.names=FALSE)

    dfs2 <- lapply(bib, function(x) x[[3]])
    dfs2 <- do.call(rbind, dfs2)
    write.table(dfs2, end_gene_file, sep="\t", quote=F, row.names=FALSE)
}

split_fusion()
