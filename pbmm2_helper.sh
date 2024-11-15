#!/bin/bash
#SBATCH --job-name pbmm2
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR=${SIM_STORAGE_DIR}/longreads_${9}k
DATADIR_PBMM2=${ALIGNMENT_STORAGE_DIR}/longreads_${9}k_PBMM2_new

[ ! -d ${DATADIR_PBMM2} ] && mkdir ${DATADIR_PBMM2}

pbmm2 align -j ${THREADS} --preset ISOSEQ --sort ${PBMM2_MMI} ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz ${DATADIR_PBMM2}/fusions-${1}-${5}-${6}-${4}-pbmm2.bam
