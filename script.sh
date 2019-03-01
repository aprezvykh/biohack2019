#!/bin/bash
genome='../genomes/Aegilops_tauschii.Aet_v4.0.dna.toplevel.fa'
element='taushi.fasta'

sec_genome='../genomes/Triticum_urartu.ASM34745v1.dna.toplevel.fa'


genome_real=$(realpath $genome)
sec_genome_real=$(realpath $sec_genome)
element_real=$(realpath $element)


mkdir single_fa
samtools faidx $element_real
trans_ids=$(cat $element_real | grep ">" | awk '{print $1}' | sed "s/>//")

for f in $trans_ids;
	do
		echo $f
		samtools faidx $element_real $f > single_fa/$f.fasta
	done

#rm -r single_fa/
fasta_list=$(ls single_fa/*.fasta)

for f in $fasta_list;
	do
		prefix=$(cat $f | head -n 1 | sed "s/>//")
		echo "$prefix first blast iteration"
		blastn -query $f -db $genome_real -num_threads 32 -max_target_seqs 10000000 -outfmt  \
			 "10 qseqid sseqid qlen qstart qend sstart send sseq mismatch gapopen" > $prefix.seq
		./script.R $prefix.seq $prefix
		cp $prefix.firGen.outfmt6 $prefix.alignments.fasta res/
		echo "$prefix second blast iteration"
		blastn -query $prefix.alignments.fasta -db $sec_genome_real -num_threads 32  -max_target_seqs 10000000 \
		-outfmt 6 > $prefix.secGen.outfmt6
		cp $prefix.secGen.outfmt6 res/
	done
