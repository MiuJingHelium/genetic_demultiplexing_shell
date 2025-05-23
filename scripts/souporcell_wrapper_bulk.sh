#!/bin/bash

WD=$1
BAM=$2
BC=$3
sample=$4

mkdir -p $WD/tmp/$sample
export TMPDIR=$WD/tmp/$sample
mkdir -p souporcell/$sample

cd $WD # note the WD


souporcell_pipeline.py \
    -i $BAM -b $BC \
    -f /storage1/fs1/martyomov/Active/References/10X/SC/Human/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa\
    -t 8 -o souporcell/${sample} -k 4 --ignore IGNORE

   