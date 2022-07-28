#!/usr/bin/bash

module load minimap2

minimap2 -ax splice --cs Plodia_genome_Scully_2022-edit.fa Pinterpunctella_GIGA_transcripts.fasta > minimap2.alignments.tmp.sam

