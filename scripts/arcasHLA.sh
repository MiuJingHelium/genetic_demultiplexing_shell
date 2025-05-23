#!/bin/bash
WD=$1
SAMPLE=$2
BAM=$3 # full path
OUTDIR=$4

cd $WD
source activate arcas-hla
chmod +rw ./arcasHLA/
chmod +x ./arcasHLA/arcasHLA

# step 0: update reference
# ./arcasHLA/arcasHLA reference --version 3.34.0
# command run in interactive mode before jobs

# step 1: extract chr6; input bam and produce fastq files
mkdir -p ./tmp/$SAMPLE

./arcasHLA/arcasHLA extract --o $OUTDIR --temp $WD/tmp/ -t 4 -v $BAM
## Output: sample.extracted.1.fq.gz, sample.extracted.2.fq.gz

# step 2: genotyping using extracted fastq files
./arcasHLA/arcasHLA genotype \
    --o $OUTDIR \
    --temp ./tmp/ \
    -t 4 -v \
    ${OUTDIR}/${SAMPLE}.extracted.1.fq.gz ${OUTDIR}/${SAMPLE}.extracted.2.fq.gz
## Output: sample.alignment.p, sample.em.json, sample.genotype.json


# step 3: merge json files to tsv
./arcasHLA/arcasHLA merge --run $SAMPLE --i $OUTDIR --o $OUTDIR -v

rm -r $WD/tmp/$SAMPLE