#!/bin/bash
WD=$1
INDIR=$2
sample=$3
mkdir -p $WD/tmp/$sample
export TMPDIR=$WD/tmp/$sample

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/

cd $WD

case "$sample" in
    "L1")
    BAM_dir=${STORAGE_LOC}/align_outs/${sample}_TOTAL/outs/per_sample_outs/${sample}_TOTAL/count
    BAM=${BAM_dir}/sample_alignments.bam
    ID_LIST=(Control_ALS4010 Control_ALS4017) #ALS4003 ALS4009 ALS4019 C67 

    for ID in ${ID_LIST[@]}; do
        patient_id=Late_${ID}
        OUTDIR=${WD}/split_bam/${sample}/${patient_id}/
        BC=${INDIR}/${sample}/${patient_id}.txt
        mkdir -p ${OUTDIR}
        ./subset-bam_linux \
            --bam $BAM \
            --cell-barcodes $BC \
            --out-bam ${OUTDIR}/${patient_id}.bam \
            --cores 4

        done
    ;;
    "M1")
        BAM_dir=${STORAGE_LOC}/align_outs/${sample}_TOTAL/outs/per_sample_outs/${sample}_TOTAL/count
        BAM=${BAM_dir}/sample_alignments.bam
        ID_LIST=(C44 C58) #ALS4005 ALS4013 ALS4018 C43

        for ID in ${ID_LIST[@]}; do
            patient_id=Mid_${ID}
            OUTDIR=${WD}/split_bam/${sample}/${patient_id}/
            BC=${INDIR}/${sample}/${patient_id}.txt
            mkdir -p ${OUTDIR}
            ./subset-bam_linux \
            --bam $BAM \
            --cell-barcodes $BC \
            --out-bam ${OUTDIR}/${patient_id}.bam \
            --cores 4

        done
    ;;
    "E1")
        BAM_dir=${STORAGE_LOC}/align_outs/${sample}_TOTAL/outs/per_sample_outs/${sample}_TOTAL/count
        BAM=${BAM_dir}/sample_alignments.bam
        ID_LIST=(Control_ALS4015) # ALS4020 ALS4014 ALS4022 C20 C23

        for ID in ${ID_LIST[@]}; do
            patient_id=Early_${ID}
            OUTDIR=${WD}/split_bam/${sample}/${patient_id}/
            BC=${INDIR}/${sample}/${patient_id}.txt
            mkdir -p ${OUTDIR}
            ./subset-bam_linux \
            --bam $BAM \
            --cell-barcodes $BC \
            --out-bam ${OUTDIR}/${patient_id}.bam \
            --cores 4

        done
    ;;
esac
    
# for f in ${BC_list[@]}; do
#            REMOVE=".txt"
#            patient_id=${f%*$REMOVE*}
#            OUTDIR=${WD}/split_bam/${sample}/${patient_id}/
#            BC=${INDIR}/${sample}/${f}
#            mkdir -p ${OUTDIR}
#            ./subset-bam_linux \
#                --bam $BAM \
#                --cell-barcodes $BC \
#                --out-bam ${OUTDIR}/${patient_id}.bam \
#                --cores 4 \
#                --log-level info
#
#        done 