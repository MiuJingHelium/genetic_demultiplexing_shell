#!/bin/bash

WD=$1
sorc_dir=$2

cd $WD

STORAGE_LOC=/storage1/fs1/martyomov/Active/collaborations/carisa/Campisi/ALS_human/
export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/  /scratch1/fs1/martyomov:/scratch1/fs1/martyomov /home/carisa:/home/carisa" 


    
     LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub -q martyomov -G compute-martyomov \
            -J unique_snp -n 8 -M 64GB -o unique_snp.out \
	        -e unique_snp.err -R 'select[mem>64MB] rusage[mem=64GB] span[hosts=1]' \
            -a "docker(kalisaz/scrna-extra:r4.4.0)" /bin/bash -c \
            "Rscript ../snakemake/only_unique_snp.R $sorc_dir"
  
