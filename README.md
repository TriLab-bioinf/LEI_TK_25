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
module load blast/2.13.0+

makeblastdb -in Plodia_genome_Scully_2022.with_START_STOP_INFRAME.transcripts.fasta -dbtype nucl

blastn -query plo_final_annotation.transcripts.fasta -db Plodia_genome_Scully_2022.with_START_STOP_INFRAME.transcripts.fasta -evalue 1e-5 -num_descriptions 5 -num_alignments 5 -o
ut plo_final_annotation_VS_NOFRAME.tbl.bn -outfmt '7 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen qcovs'

# Full length quantification:
grep -v '^#' plo_final_annotation_VS_NOFRAME.tbl.bn|grep '100$'|cut -f 1|sort -u |wc

# Total:
grep -v '^#' plo_final_annotation_VS_NOFRAME.tbl.bn|cut -f 1|sort -u |wc
```

This analysis showed that :

- 12078 GigaDB genes mapped to Leah's assembly (10955 as full length).
- 11216 GigaDB genes mapped to Leah's assembly conserving the START and STOP codons (10955 full length).
- 10877 GigaDB genes mapped to Leah's assembly conserving the START and STOP codons which are also in-frame (10593 are full length).

* New annotation using Leah's RNAseq PacBio data:

First PacBio RNAseq reads were clustered at high stringency with cd-hit using the following command:

```
sbatch --mem=64g --cpus-per-task=16 run_cdhit_est.sh

```
One representative transcript per cluster was then used for the analysis below.

For generating annotation based on Leah's RNAseq data I used the following commands:

```
sbatch --time=4:00:00 --partition=quick --mem=32g run_minimap2.sh Plodia_genome_Scully_2022-edit.fa SRR15699974_subreads.cdhit.fasta minimap2.alignments.leah_rnaseq.tmp
samtools sort -o minimap2.alignments.leah_rnaseq.bam minimap2.alignments.leah_rnaseq.tmp.sam
./sam_to_gtf.pl minimap2.alignments.leah_rnaseq.bam > minimap2.alignments.leah_rnaseq.gtf
cat minimap2.alignments.leah_rnaseq.gtf|./get_genes_from_gtf.pl > Pinterpunctella_LEAH.leah_rnaseq.gff
gffread Pinterpunctella_LEAH.leah_rnaseq.gff -g ./Plodia_genome_Scully_2022-edit.fa -w Plodia_genome_Scully_2022.transcripts.leah_rnaseq.fasta -A
```

**Merging genes that overlap at least 500bp in new gff**

GFF genes that overlap at least 500bp were detected with bedtools (v2.30.0):
```
egrep '\tgene\t' Pinterpunctella_LEAH.plo_final.gff > tmp.gff
bedtools cluster -s -d -500 -i tmp.gff > tmp.500bp.bed
```
Then, overlappping gff annotation was merged as described below:
```
./merge_overlapping_genes.pl -b tmp.500bp.bed -g Pinterpunctella_LEAH.plo_final.gff >  Pinterpunctella_LEAH.plo_final.clustered.gff.tmp
```
The resulting gff file was then sorted by gene position and mRNA position:
```
egrep '\tgene\t' Pinterpunctella_LEAH.plo_final.clustered.gff.tmp |cut -f 2 -d '"' > cluster.ids
for i in `cat cluster.ids`; do echo $i; grep -w $i Pinterpunctella_LEAH.plo_final.clustered.gff.tmp >> sorted.gff; done 
```
The sorted gff was afterwards processed to eliminate redundant transcripts that share exactly the same exonic structure:
```
cat sorted.gff | ./remove_redundant_transcripts.pl > mRNA.NR.ids
egrep -wf mRNA.NR.ids sorted.gff > sorted.NR.gff
```

**New gene merge protocol by percent overlap (>=50% of smallest gene)**

```
./merge_genes_from_gff.py -g Pinterpunctella_LEAH.plo_final.gff -o 0.5 > tmp.500bp_NEW.bed

./merge_overlapping_genes.pl -b tmp.500bp_NEW.bed -g Pinterpunctella_LEAH.plo_final.gff >  Pinterpunctella_LEAH.plo_final.clustered_NEW.gff.tmp

egrep '\tgene\t' Pinterpunctella_LEAH.plo_final.clustered_NEW.gff.tmp |cut -f 2 -d '"' > cluster_NEW.ids

for i in `cat cluster_NEW.ids`; do echo $i; grep -w $i Pinterpunctella_LEAH.plo_final.clustered_NEW.gff.tmp >> sorted_NEW.gff; done

cat sorted_NEW.gff| ./remove_redundant_transcripts.pl > mRNA_NEW.NR.ids

egrep -wf mRNA_NEW.NR.ids sorted_NEW.gff > sorted_NEW.NR.gff
```
