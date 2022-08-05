#!/Users/lorenziha/opt/anaconda3/envs/snp_caller/bin/perl
use strict;

#scaffold1   GIGAdb  gene    74566   84663   .   +   .   ID="gene_N199"; Evidence_id="plodia_orig_RNA-XM_038021548.1_R7.p1";
#scaffold1   GIGAdb  mRNA    74566   76212   .   +   .   ID="mRNA_15"; Parent="gene_N199" ;Evidence_id="plodia_orig_RNA-XM_038021548.1_R7.p1";
#scaffold1   GIGAdb  exon    74566   74788   .   +   .   ID="exon_15.1"; Exon_number="1"; gene_id="gene_N199";Parent="mRNA_15"
#scaffold1   GIGAdb  exon    74876   75503   .   +   .   ID="exon_15.2"; Exon_number="2"; gene_id="gene_N199";Parent="mRNA_15"
#scaffold1   GIGAdb  exon    75585   76212   .   +   .   ID="exon_15.3"; Exon_number="3"; gene_id="gene_N199";Parent="mRNA_15"
#scaffold1   GIGAdb  mRNA    74566   76212   .   +   .   ID="mRNA_16"; Parent="gene_N199" ;Evidence_id="plodia_orig_RNA-XM_038021548.1_R9.p1";
#scaffold1   GIGAdb  exon    74566   74788   .   +   .   ID="exon_16.1"; Exon_number="1"; gene_id="gene_N199";Parent="mRNA_16"
#scaffold1   GIGAdb  exon    74876   75503   .   +   .   ID="exon_16.2"; Exon_number="2"; gene_id="gene_N199";Parent="mRNA_16"
#scaffold1   GIGAdb  exon    75585   76212   .   +   .   ID="exon_16.3"; Exon_number="3"; gene_id="gene_N199";Parent="mRNA_16"
#scaffold1   GIGAdb  mRNA    74566   84663   .   +   .   ID="mRNA_17"; Parent="gene_N199" ;Evidence_id="plodia_orig_RNA-XM_038021548.1_R1.p1";
#scaffold1   GIGAdb  exon    74566   74788   .   +   .   ID="exon_17.1"; Exon_number="1"; gene_id="gene_N199";Parent="mRNA_17"
#scaffold1   GIGAdb  exon    74876   75503   .   +   .   ID="exon_17.2"; Exon_number="2"; gene_id="gene_N199";Parent="mRNA_17"
#scaffold1   GIGAdb  exon    75585   76166   .   +   .   ID="exon_17.3"; Exon_number="3"; gene_id="gene_N199";Parent="mRNA_17"
#scaffold1   GIGAdb  exon    84618   84663   .   +   .   ID="exon_17.4"; Exon_number="4"; gene_id="gene_N199";Parent="mRNA_17

# output mRNA IDs to be removed

my %iso;
while(<>){
	chomp;
	my @x = split /\t/;
	next unless $x[2] eq 'exon';
	my $id = $1 if m/Parent=.(mRNA_\d+)/;
	$iso{$id} .= $x[0].'_'.$x[3].'_'.$x[4].'_';
}

my %nr_iso;
foreach my $k (keys %iso){
	$nr_iso{$iso{$k}}= $k;
}

foreach my $nk (keys %nr_iso){
	print  $nr_iso{$nk}."\n";
}
