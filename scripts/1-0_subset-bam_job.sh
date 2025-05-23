#!/bin/bash

WD=$1
INDIR=$2
cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 

#wget https://github.com/10XGenomics/subset-bam/releases/download/v1.1.0/subset-bam_linux
#chmod +x subset-bam_linux/subset-bam_linux

SAMPLES=("E1" "M1" "L1") #  
for sample in ${SAMPLES[@]}; do
    LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
        -J ${sample}_subset -n 8 -M 128GB -o ${sample}_subset.out \
	-e ${sample}_subset.err -R 'select[mem>128MB] rusage[mem=128GB] span[hosts=1]' \
        -a "docker(ubuntu:22.04)" /bin/bash -c \
        "./subset-bam.sh $WD $INDIR $sample"
    
done