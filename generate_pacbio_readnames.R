if (!require("BiocManager", quietly = TRUE))
	install.packages("BiocManager", repo='https://archive.linux.duke.edu/cran/')
if (!require("ShortRead", quietly = TRUE))
	BiocManager::install("ShortRead")

library("ShortRead")

arg <- commandArgs(trailingOnly=TRUE)

fq <- readFastq(arg[1])

new_names <- paste0("transcript/", seq_along(fq))

writeFastq(fq, arg[1])
