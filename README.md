Generation of annotation gff file for Leah's P. interpunctella assembly

Annotation source: http://gigadb.org/dataset/view/id/102231/File_sort/type_id

Protocol:

P. interpunctella transcripts were mapped to Leah's assembly with minimap2 using the following command:

```
module load minimap2

minimap2 -ax splice --cs Plodia_genome_Scully_2022-edit.fa Pinterpunctella_GIGA_transcripts.fasta > minimap2.alignments.tmp.sam
```


