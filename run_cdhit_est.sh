#!/usr/bin/bash

 module load cd-hit

 cd-hit-est -i SRR15699974_subreads.fasta -o SRR15699974_subreads.cdhit.fasta -c 0.9 -T 16 -M 2600

