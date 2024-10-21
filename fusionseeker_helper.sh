#!/bin/bash
#SBATCH --job-name fusionseeker
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 10g

DATADIR_MINIMAP=${ALIGNMENT_STORAGE_DIR}/longreads_${9}k_minimap2
FUSIONSEEKER_DIR=${FUSIONSEEKER_STORAGE_DIR}/longreads_${9}k_fusionseeker

[ ! -d ${FUSIONSEEKER_DIR} ] && mkdir ${FUSIONSEEKER_DIR}

/home/vantwisk/FusionSeeker/fusionseeker \
  --thread 32 \
  --bam ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-sorted.bam \
  --datatype nanopore \
  --human38 \
  --outpath ${FUSIONSEEKER_DIR}/fusions-${1}-${5}-${6}-${4}-fusionseeker \
  -s 2

#fusionseeker \
#  --thread 16 \
#  --bam ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-sorted.bam \
#  --gtf ${GTF_REFERENCE} \
#  --ref ${DNA_REFERENCE} \
#  -o ${FUSIONSEEKER_DIR}/fusions-${1}-${5}-${6}-${4}-fusionseeker \
#  -s 2
