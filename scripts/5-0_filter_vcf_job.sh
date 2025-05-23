#!/bin/bash

WD=$1
sorc_dir=$2

cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 

# submit 1 job per stage
# the filter vcf will be performed over the entire pool


SAMPLES=$(ls $sorc_dir)
for sample in ${SAMPLES[@]}; do
     LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${sample}_filter_vcf -n 8 -M 64GB -o ${sample}_filter_vcf.out \
	        -e ${sample}_filter_vcf.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(python:3.6.15-slim-buster)" /bin/bash -c \
            "python snakemake/filter_vcf.py sorc_bulk/${sample}/"
  
done