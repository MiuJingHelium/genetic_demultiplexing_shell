#!/bin/bash

WD=$1
BAM=$2
BC=$3
VCF=$4
OUTDIR=$5


mkdir -p $OUTDIR

cd $WD # note the WD

souporcell_pipeline.py \
    -i $BAM -b $BC \
    -f /storage1/fs1/martyomov/Active/References/10X/SC/Human/refdata-gex-GRCh38-2024-A/fasta/genome.fa \
    -t 8 -o $OUTDIR -k 6 \
    --known_genotypes $VCF 
gunzip $OUTDIR/souporcell_merged_sorted_vcf.vcf.gz


   