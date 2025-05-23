#!/bin/bash

WD=$1
BAM_dir=$2 # probably split-bam/
BC_dir=$3

cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 

#wget https://github.com/10XGenomics/subset-bam/releases/download/v1.1.0/subset-bam_linux
#chmod +x subset-bam_linux/subset-bam_linux

SAMPLES=("E1" "M1" "L1") #  
for sample in ${SAMPLES[@]}; do
    PATIENTS=$(ls ${BAM_dir}/${sample})
    for patient in ${PATIENTS[@]}; do

        LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${patient}_sorc -n 8 -M 64GB -o ${patient}_sorc.out \
	        -e ${patient}_sorc.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(cumulusprod/souporcell:2.5)" /bin/bash -c \
            "./souporcell_wrapper.sh $WD $BAM_dir $BC_dir $sample $patient"
    done
done