**Generation of annotation gff file for Leah's P. interpunctella assembly**

Annotation source: http://gigadb.org/dataset/view/id/102231/File_sort/type_id

*Protocol:*

*P. interpunctella* transcripts were mapped to Leah's assembly with minimap2 using the following command:

```
module load minimap2

minimap2 -ax splice --cs Plodia_genome_Scully_2022-edit.fa Pinterpunctella_GIGA_transcripts.fasta > minimap2.alignments.tmp.sam
```
The resulting sam file was sorted by read coordinate:

```
module load samtools

samtools sort -o minimap2.alignments.bam minimap2.alignments.tmp.sam
```

The sorted bam file was processed with sam_to_gtf.pl to generate a temporary gtf file:

```
sam_to_gtf.pl minimap2.alignments.bam > minimap2.alignments.gtf
```

Finally minimap2.alignments.gt was processed by get_genes_from_gtf.pl script to generate the final gff file with the annotation:

```
 cat minimap2.alignments.gtf|./get_genes_from_gtf.pl > Pinterpunctella_LEAH.gff
```

Transcript sequences can be regenerated using the Pinterpunctella_LEAH.gff and the assembly files like this:
```
module load cufflinks
gffread Pinterpunctella_LEAH.gtf -g ./Plodia_genome_Scully_2022-edit.fa -w test -A
```

