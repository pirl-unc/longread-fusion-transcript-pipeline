#!/bin/bash
#SBATCH --job-name pbfusion
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR_MINIMAP=/datastore/scratch/users/vantwisk/sim/longreads_training${9}k_minimap2
DATADIR_BPFUSION=/datastore/scratch/users/vantwisk/sim/longreads_training${9}k_pbfusion

[ ! -d ${DATADIR_BPFUSION} ] && mkdir ${DATADIR_BPFUSION}

pbfusion discover \
    --bam ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-pbmm2.bam \
    --gtf ../gencode.v38.annotation.gtf \
    --output-prefix ${DATADIR_PBFUSION}/fusions-${1}-${5}-${6}-${4}-pbmm2- \
    --min-coverage 1 \
    --threads 32 -v
