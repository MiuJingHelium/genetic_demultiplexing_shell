#!/bin/bash

WD=$1
bulk_dir=$2
sorc_dir=$3

cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 

# submit 1 job per stage
# the filter vcf will be performed over the entire pool


SAMPLES=$(ls $bulk_dir)
for sample in ${SAMPLES[@]}; do
    input="$bulk_dir/$sample/souporcell_merged_sorted_vcf.vcf"
    header="$bulk_dir/$sample/header.txt"
    head -n 257 ${input} > ${header}

    vcf="$sorc_dir/only_unique_snp.vcf"
    out_vcf="$bulk_dir/$sample/only_unique_snp_header.vcf"
    echo "$(cat ${header} ${vcf})" > ${out_vcf} # store out vcf to bulk


     LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${sample}_filter_vcf_header -n 8 -M 64GB -o ${sample}_filter_vcf_header.out \
	        -e ${sample}_filter_vcf_header.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(biocontainers/picard-tools:v2.18.25dfsg-2-deb_cv1)" /bin/bash -c \
            "/usr/bin/picard-tools FixVcfHeader I=${out_vcf} O=${out_vcf}"
    
done