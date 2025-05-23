#!/bin/bash

WD=$1

cd $WD

samples=$(ls souporcell/)

for sample in ${samples[@]}; do
    gunzip souporcell/${sample}/souporcell_merged_sorted_vcf.vcf.gz
done