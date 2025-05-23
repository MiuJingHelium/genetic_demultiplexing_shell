# genetic_demultiplexing_shell
Repo of shell scripts for genetic demultiplexing of pooled scRNA-seq data. I live in the Stone Age, and that's why I use shell/bash. Credit to snakemake pipeline written by Marina Terekhova (github repo: https://github.com/teresho4/scRNA-seq_atlas_Hs_PBMC_aging/tree/main).
The original R and Python scripts have been moditifed to make sure the same pipeline can be ran over a slightly different set-up of files as well as samples.

WashU RIS uses IBM LSF schedulers and dockers, so each step may involve a job script that calls another wrapper script that performs the actual step. The job scripts to be submitted are ordered by their step numbers. I may not have updated some of paths given that there were changes in file location during the demultiplexing process.

Maybe I'll clean up the scripts and optimize them later on. 
![The codes do run, don't they](https://preview.redd.it/4dnvvjeuq0541.jpg?width=640&crop=smart&auto=webp&s=af02d59262a047fa6fadacf51cbf108ea2c0647a)
