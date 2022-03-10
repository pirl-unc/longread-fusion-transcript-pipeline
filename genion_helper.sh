#!/bin/bash
#SBATCH --job-name genion
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR=longreads
MINIMAP_DATADIR=longreads_mappings
GENION_DATADIR=longreads_genion

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
  genion \
  -t 32 \
  --min-support 2 \
  -i ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz \
  --gtf Homo_sapiens.GRCh38.105.gtf \
  --gpaf ${MINIMAP_DATADIR}/fusions-${1}-${5}-${6}-${4}.paf \
  -s ${MINIMAP_DATADIR}/fusions-${1}-${5}-${6}-${4}-selfalign.tsv \
  -d genomicSuperDups.txt \
  -o ${GENION_DATADIR}/fusions-${1}-${5}-${6}-${4}-genion.tsv
