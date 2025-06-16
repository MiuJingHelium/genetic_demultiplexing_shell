#!/bin/bash

WD=$1
SORC_DIR=$2 # probably sorc_bulk/

# OUTDIR="sorc_step2/"
# mkdir -p $OUTDIR
cd $WD

align_dir=/scratch1/fs1/martyomov/carisa/Laura_Tot_Count/align_outs/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 


# I used the wrong barcode file for the bulk so now I need to re-run

SAMPLES=("E1" "M1" "L1") #  
for sample in ${SAMPLES[@]}; do
        BAM=${align_dir}/${sample}_TOTAL/outs/possorted_genome_bam.bam

        #cp ${align_dir}/${sample}_TOTAL/outs/filtered_feature_bc_matrix/barcodes.tsv.gz ${align_dir}/${sample}_TOTAL/outs/barcodes.tsv.gz
        #gunzip ${align_dir}/${sample}_TOTAL/outs/barcodes.tsv.gz

        BC=${align_dir}/${sample}_TOTAL/outs/barcodes.tsv
        VCF=${SORC_DIR}/${sample}/only_unique_snp_header.vcf
        OUT_dir=${SORC_DIR}/${sample}/

        LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${sample}_sorc_2 -n 8 -M 64GB -o ${sample}_sorc_2.out \
	        -e ${sample}_sorc_2.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(cumulusprod/souporcell:2.5)" /bin/bash -c \
            "./scripts/souporcell_step2_wrapper.sh $WD $BAM $BC $VCF $OUT_dir"

done

