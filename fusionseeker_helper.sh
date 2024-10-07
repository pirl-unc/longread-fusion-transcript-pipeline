#!/bin/bash
#SBATCH --job-name longgf
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 10g

DATADIR_MINIMAP=/datastore/scratch/users/vantwisk/sim/longreads_training${12}k_minimap2
FUSIONSEEKER_DIR=/datastore/scratch/users/vantwisk/sim/longreads_training${12}k_fusionseeker

[ ! -d ${FUSIONSEEKER_DIR} ] && mkdir ${FUSIONSEEKER_DIR}

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
fusionseeker \
  --tread 16 \
  --bam ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-sorted.bam \
  --gtf Homo_sapiens.GRCh38.105.gtf \
  --ref ../hg38.fa \
  -o ${FUSIONSEEKER_DIR}/fusions-${1}-${5}-${6}-${4}-fusionseeker \
  -s 2
