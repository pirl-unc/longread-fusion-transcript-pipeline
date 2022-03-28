#!/bin/bash
#SBATCH --job-name longgf
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 10g

MINIMAP_DIR=${7}
LONGGF_DIR=${8}

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
~/LongGF/bin/LongGF \
  ${MINIMAP_DIR}/fusions-${1}-${5}-${6}-${4}-sorted-n.bam \
  Homo_sapiens.GRCh38.105.gtf \
  40 50 100 > ${LONGGF_DIR}/fusions-${1}-${5}-${6}-${4}.log
