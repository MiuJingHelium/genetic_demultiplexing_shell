#!/bin/bash

WD=$1 # remember to use the snakemake folder!!

export LSF_DOCKER_VOLUMES="/storage1/fs1/martyomov/Active/:/storage1/fs1/martyomov/Active/ /scratch1/fs1/martyomov/carisa:/scratch1/fs1/martyomov/carisa /home/carisa:/home/carisa"

cd $WD

LSF_DOCKER_PRESERVE_ENVIRONMENT=false  bsub -q martyomov -G compute-martyomov \
    -J souporcell_smk -n 8 -M 128GB -o souporcell_smk.out \
    -e souporcell_smk.err -R 'rusage[mem=128GB]' \
    -a "docker(biolabs/snakemake:6.4.1_conda4.10.1_py38)" /bin/bash -c \
    "source /etc/bash.bashrc; cd $WD; export TMPDIR=/storage1/fs1/martyomov/Active/IndividualBackUps/carisa/.cache/; snakemake --use-conda --cores all"

