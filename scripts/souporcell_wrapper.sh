#!/bin/bash

#!/bin/bash
WD=$1
BAM_dir=$2
BC_dir=$3
sample=$4
patient=$5

mkdir -p $WD/tmp/$patient
export TMPDIR=$WD/tmp/$patient
mkdir -p souporcell/$patient


STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/

cd $WD # note the WD


souporcell_pipeline.py \
    -i ${BAM_dir}/$sample/$patient/${patient}.bam -b $BC_dir/$sample/${patient}.txt \
    -f /storage1/fs1/martyomov/Active/References/10X/SC/Human/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa\
    -t 8 -o souporcell/${patient} -k 4

gunzip souporcell/${patient}/souporcell_merged_sorted_vcf.vcf.gz
