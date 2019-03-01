#!/bin/bash
genome='../genomes/Aegilops_tauschii.Aet_v4.0.dna.toplevel.fa'
element='../single_LTR_sabrina_RLG_Atau_Sabrina_B_AF497474-1/seq.fasta'

genome_real=$(realpath $genome)
element_real=$(realpath $element)

prefix=$(cat $element_real | head -n 1 | sed "s/>//")

blastn -query $element_real -db $genome_real -num_threads 64 -max_target_seqs 10000000 -outfmt  \
	 "10 qseqid sseqid qlen qstart qend sstart send sseq" > $prefix.seq

./script.R $element_real.seq $prefix
