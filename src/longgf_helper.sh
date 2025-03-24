#!/bin/bash
#SBATCH --job-name longgf
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 10g

DATADIR_MINIMAP=${ALIGNMENT_STORAGE_DIR}/longreads_${12}k_minimap2
LONGGF_DIR=${LONGGF_STORAGE_DIR}/longreads_${12}k_longgf

[ ! -d ${LONGGF_DIR} ] && mkdir ${LONGGF_DIR}

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
/home/vantwisk/LongGF/bin/LongGF \
  ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-n-sorted.bam \
  ${GTF_REFERENCE} \
  ${9} ${10} ${11} > ${LONGGF_DIR}/fusions-${1}-${5}-${6}-${4}-${9}-${10}-${11}.log
