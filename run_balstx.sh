#!/usr/bin/bash

module load blast

blastx -query Plodia_genome_Scully_2022.transcripts.fasta -db plo_predicted_proteins.fasta -evalue 1e-5 -word_size 3 -out transcrip_vs_gigadb_prot.bx -outfmt "7 qaccver saccver pident length mismatch gapopen qstart qend sstart send qlen slen" -max_target_seqs 5

