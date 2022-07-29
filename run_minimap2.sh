#!/usr/bin/bash

MY_GENOME=$1
MY_TRANSCRIPTS=$2
MY_PREFIX=$3

module load minimap2

minimap2 -ax splice --cs ${MY_GENOME} ${MY_TRANSCRIPTS} > ${MY_PREFIX}.sam

