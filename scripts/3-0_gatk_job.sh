#!/bin/bash

WD=$1
sorc_dir=$2

cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 


SAMPLES=$(ls $sorc_dir)
for sample in ${SAMPLES[@]}; do
    vcf="${sorc_dir}/${sample}/souporcell_merged_sorted_vcf.vcf"
    output="${sorc_dir}/${sample}/vcf_table.tsv"

     LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${sample}_gatk -n 8 -M 64GB -o ${sample}_gatk.out \
	        -e ${sample}_gatk.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(broadinstitute/gatk:4.6.2.0)" /bin/bash -c \
            "gatk --java-options '-Xmx4G' VariantsToTable --variant ${vcf} --output ${output} -F CHROM -F POS -GF GT"
  
done