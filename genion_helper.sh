#!/bin/bash
#SBATCH --job-name genion
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
  genion \
  -t 32 \
  -i pfun-med/fuse-${1}-${4}.fq.gz \
  --gtf Homo_sapiens.GRCh38.105.gtf \
  --gpaf pfun-med/fuse-${1}-${4}-minimap2-splice.paf \
  -s cdna.self.tsv \
  -d genomicSuperDups.txt \
  -o pfun-med/fuse-${1}-${4}-minimap2-splice_genion.tsv
