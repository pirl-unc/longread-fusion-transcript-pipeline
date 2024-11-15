#!/bin/bash
#SBATCH --job-name pbfusion
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR_PBMM2=${ALIGNMENT_STORAGE_DIR}/longreads_${9}k_PBMM2_new
DATADIR_PBFUSION=${PBFUSION_STORAGE_DIR}/longreads_${9}k_pbfusion

[ ! -d ${DATADIR_PBFUSION} ] && mkdir ${DATADIR_PBFUSION}

pbfusion discover \
    --gtf ${GTF_REFERENCE} \
    --output-prefix ${DATADIR_PBFUSION}/fusions-${1}-${5}-${6}-${4}-pbmm2- \
    --threads ${THREADS} \
    -v \
    ${DATADIR_PBMM2}/fusions-${1}-${5}-${6}-${4}-pbmm2.bam \
