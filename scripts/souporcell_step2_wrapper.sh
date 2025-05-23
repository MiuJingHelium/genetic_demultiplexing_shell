#!/bin/bash

WD=$1
BAM=$2
BC=$3
VCF=$4
OUTDIR=$5 # probably sorc_bulk/$sample

mkdir -p $OUTDIR

cd $WD # note the WD

vartrix --mapq 30 -b $BAM -c $BC \
    --scoring-method coverage --threads 8 \
    --ref-matrix $OUTDIR/ref.mtx \
    --out-matrix $OUTDIR/alt.mtx -v $VCF \
    --fasta /storage1/fs1/martyomov/Active/References/10X/SC/Human/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa --umi

~/souporcell/souporcell/target/release/souporcell \
    -k 6 -a $OUTDIR/alt.mtx -r $OUTDIR/ref.mtx \
    --restarts 100 -b $BC --min_ref 10 \
    --min_alt 10 > $OUTDIR/clusters_tmp.tsv

~/souporcell/troublet/target/release/troublet \
    --alts $OUTDIR/alt.mtx --refs $OUTDIR/ref.mtx \
    --clusters $OUTDIR/clusters_tmp.tsv >  $OUTDIR/clusters.tsv

~/souporcell/consensus.py \
    -c $OUTDIR/clusters.tsv  \
    -a $OUTDIR/alt.mtx \
    -r $OUTDIR/ref.mtx \
    -p 2 --output_dir $OUTDIR --soup_out $OUTDIR/ambient_rna.txt \
    --vcf_out $OUTDIR/cluster_genotypes.vcf --vcf $VCF