#!/usr/bin/Rscript
exit <- function() {
  .Internal(.invokeRestart(list(NULL, NULL), NULL))
}
args <- commandArgs()
cat("Parsing!", sep = "\n")

blast <- args[6]
prefix <- args[7]

bl <- read.table(blast,sep = ",",stringsAsFactors = F)
names(bl) <- c("query_id", "chr", "q_length", "qstart", "qend", "sstart", "send" ,"seq", "mm", "gap")

bl$idx <- seq(1:nrow(bl))
bl$length <- bl$qend - bl$qstart
bl$seq <- gsub("-", "", bl$seq)

sink(paste(prefix, ".alignments.fasta", sep = ""))

cat(paste(">", bl$query_id, "@",bl$chr, "@", bl$sstart, "@",  bl$send,"@", bl$mm,"@",bl$gap, "\n",
          bl$seq, "\n", sep = ""), sep = "\n")
sink()
