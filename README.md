**Generation of annotation gff file for Leah's P. interpunctella assembly**

Annotation source: http://gigadb.org/dataset/view/id/102231/File_sort/type_id

*Protocol:*

*P. interpunctella* predicted transcripts from Gigadb were generated from plo_final_annotation.gff using the following commands:

```
sed -e 's/prediction/mRNA/' plo_final_annotation.gff > plo_final_annotation_mRNA.gff
gffread plo_final_annotation_mRNA.gff -g PinterpunctellaAssembly.asm.p_ctg_editedv6.fa -w plo_final_annotation.transcripts.fasta -A
```

Total transcripts in source genome = 12122 (a few genes didn't produce any transcript given that two GigaDB contigs (ptg000001l and ptg000049l) were not found in the source assembly).  
```
grep -c '>' plo_final_annotation.transcripts.fasta
```

Then transcripts were mapped to  Leah's P. interpunctella assembly with minimap2: 

```
sbatch --time=4:00:00 --partition=quick --mem=32g run_minimap2.sh Plodia_genome_Scully_2022-edit.fa plo_final_annotation.transcripts.fasta minimap2.alignments.plo_final.tmp
```

The resulting sam file was sorted by read coordinate:

```
module load samtools
samtools sort -o minimap2.alignments.plo_final.bam minimap2.alignments.plo_final.tmp.sam
```

The sorted bam file was processed with sam_to_gtf.pl to generate a temporary gtf file:

```
./sam_to_gtf.pl minimap2.alignments.plo_final.bam > minimap2.alignments.plo_final.gtf
```

Finally minimap2.alignments.gt was processed by get_genes_from_gtf.pl script to generate the final gff file with the annotation:

```
cat minimap2.alignments.plo_final.gtf|./get_genes_from_gtf.pl > Pinterpunctella_LEAH.plo_final.gff
```

Transcript sequences can be regenerated using the Pinterpunctella_LEAH.gff and the assembly files like this:
```
module load cufflinks
gffread Pinterpunctella_LEAH.plo_final.gff -g ./Plodia_genome_Scully_2022-edit.fa -w Plodia_genome_Scully_2022.transcripts.plo_final.fasta -A
```

*QC of genes mapped to Leah's P. interpunctella assembly*

* Quantification of new genes from Leah's assembly containing START and STOP codons, in-frame or not.

Total number of genes in Leah's assembly = 16493  
```
grep -c '>' Plodia_genome_Scully_2022.transcripts.plo_final.fasta
```

 Total number of genes in Leah's assembly with starting ATG = 15347
 ```
 cat Plodia_genome_Scully_2022.transcripts.plo_final.fasta|perl -ne 'chomp;if(m/^>/){print "\n"."$_"."\n"}else{print "$_"}' |grep -B 1 '^>' | grep -c '^ATG'
 ```

Total number of genes in Leah's assembly ending in a STOP codon = 15507
```
cat Plodia_genome_Scully_2022.transcripts.plo_final.fasta|perl -ne 'chomp;if(m/^>/){print "\n"."$_"."\n"}else{print "$_"}' |grep -B 1 '^>' | grep -c 'TAA$\|TAG$\|TGA$'
```

Total number of genes in Leah's assembly starting with ATG and  ending in a STOP codon = 14483
```
cat Plodia_genome_Scully_2022.transcripts.plo_final.fasta|perl -ne 'chomp;if(m/^>/){print "\n"."$_"."\n"}else{print "$_"}' > Plodia_genome_Scully_2022.transcripts.plo_final_2LineSeq.fasta

grep -B 1 -P "^ATG.+(TAA|TAG|TGA)$" Plodia_genome_Scully_2022.transcripts.plo_final_2LineSeq.fasta| grep -c '>'
```

 Total number of genes in Leah's assembly starting with ATG, ending in a STOP codon and ATG and STOP codons are in-frame = 13598
 ```
grep -B 1 -P "^ATG(...)+(TAA|TAG|TGA)$" Plodia_genome_Scully_2022.transcripts.plo_final_2LineSeq.fasta| grep -c '>'
 ```

* Evaluation of how many genes were mapped from GigaDB assembly to Leah's:

Transcripts from  Leah's assembly were compared to GigaDB  transcripts using blastn by running the following commands:

```
module load blast

makeblastdb -in Plodia_genome_Scully_2022.with_START_STOP_INFRAME.transcripts.fasta -dbtype nucl

blastn -query plo_final_annotation.transcripts.fasta -db Plodia_genome_Scully_2022.with_START_STOP_INFRAME.transcripts.fasta -evalue 1e-5 -num_descriptions 5 -num_alignments 5 -o
ut plo_final_annotation_VS_NOFRAME.tbl.bn -outfmt '7 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen qcovs'

# Full length quantification:
grep -v '^#' plo_final_annotation_VS_NOFRAME.tbl.bn|grep '100$'|cut -f 1|sort -u |wc

# Total:
grep -v '^#' plo_final_annotation_VS_NOFRAME.tbl.bn|cut -f 1|sort -u |wc
```

This analysis showed that :

- 12078 GigaDB genes mapped to Leah's assembly (10954 as full length).
- 11216 GigaDB genes mapped to Leah's assembly conserving the START and STOP codons (10955 full length).
- 10877 GigaDB genes mapped to Leah's assembly conserving the START and STOP codons which are also in-frame (10593 are full length).












* Calculation of total genes mapped to the target assembly:






