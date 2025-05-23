#!/bin/bash

WD=$1
INDIR=$2 # split_bam
cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 
mkdir -p ./tmp/

# git clone https://github.com/RabadanLab/arcasHLA
# need to optimize workflow 
STAGES=("E1" "M1" "L1") # 

for stage in ${STAGES[@]}; do

    SAMPLES=$(ls ${INDIR}/${stage}) # list sample dir

    for sample in ${SAMPLES[@]}; do

        BAM=${INDIR}/${stage}/${sample}/${sample}.bam
        OUTDIR="HLA-typing/${stage}/${sample}/"
        mkdir -p $OUTDIR

        LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J ${sample}_HLA -n 8 -M 128GB -o ${sample}_HLA.out \
	        -e ${sample}_HLA.err -R 'select[mem>128MB] rusage[mem=128GB] span[hosts=1]' \
            -a "docker(kalisaz/arcashla:latest)" /bin/bash -c \
            "./arcasHLA.sh $WD $sample $BAM $OUTDIR"
    done
    
done