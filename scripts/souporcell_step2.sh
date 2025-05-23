#!/bin/bash

WD=$1
SORC_DIR=$2 # probably sorc_bulk/

cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 

SAMPLES=("E1" "M1" "L1") #  
for sample in ${SAMPLES[@]}; do
        BAM=${STORAGE_LOC}/align_outs/${sample}_TOTAL/outs/per_sample_outs/${sample}_TOTAL/count/sample_alignments.bam
        BC=${STORAGE_LOC}/align_outs/${sample}_TOTAL/outs/per_sample_outs/${sample}_TOTAL/count/sample_filtered_barcodes.csv
        VCF=${SORC_DIR}/${sample}/only_unique_snp_header.vcf
        OUT_dir=${SORC_DIR}/${sample}

        LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${sample}_sorc -n 8 -M 64GB -o ${sample}_sorc.out \
	        -e ${sample}_sorc.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(cumulusprod/souporcell:2.5)" /bin/bash -c \
            "./scripts/souporcell_step2_wrapper.sh $WD $BAM $BC $VCF $OUT_dir"

done

