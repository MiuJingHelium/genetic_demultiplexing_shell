#!/bin/bash

WD=$1
SORC_DIR="sorc_bulk_rerun/"

cd $WD

# STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
align_dir=/scratch1/fs1/martyomov/carisa/Laura_Tot_Count/align_outs/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 


SAMPLES=("L1") # "E1" "M1" "L1"
for sample in ${SAMPLES[@]}; do
        BAM=${align_dir}/${sample}_TOTAL/outs/possorted_genome_bam.bam
        cp ${align_dir}/${sample}_TOTAL/outs/filtered_feature_bc_matrix/barcodes.tsv.gz ${align_dir}/${sample}_TOTAL/outs/barcodes.tsv.gz
        
        gunzip ${align_dir}/${sample}_TOTAL/outs/barcodes.tsv.gz
        BC=${align_dir}/${sample}_TOTAL/outs/barcodes.tsv

        OUTDIR=${SORC_DIR}/${sample}
        mkdir -p $OUTDIR

        LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${sample}_sorc -n 8 -M 64GB -o ${sample}_sorc.out \
	        -e ${sample}_sorc.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(cumulusprod/souporcell:2.5)" /bin/bash -c \
            "./scripts/souporcell_wrapper_bulk.sh $WD $BAM $BC $sample $OUTDIR"

done