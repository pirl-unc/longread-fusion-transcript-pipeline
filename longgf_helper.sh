#!/bin/bash
#SBATCH --job-name longgf
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 10g

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
  ~/LongGF/bin/LongGF \
  fun-med/fuse-${1}-${4}-sorted_minimap2-splice.bam \
  Homo_sapiens.GRCh38.105.gtf \
  40 50 100 > fun-med/fuse-${1}-${4}-sorted_minimap2-splice.log
