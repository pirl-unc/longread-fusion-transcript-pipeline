#!/bin/bash
#SBATCH --job-name genion
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR=/datastore/scratch/users/vantwisk/sim/longreads_training${11}k
MINIMAP_DATADIR=/datastore/scratch/users/vantwisk/sim/longreads_training${11}k_minimap2
GENION_DIR=/datastore/scratch/users/vantwisk/sim/longreads_training${11}k_genion

[ ! -d ${GENION_DIR} ] && mkdir ${GENION_DIR}

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
genion \
  --min-support ${10} \
  -i ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz \
  --gtf Homo_sapiens.GRCh38.105.gtf \
  --gpaf ${MINIMAP_DATADIR}/fusions-${1}-${5}-${6}-${4}.paf \
  -s ${MINIMAP_DATADIR}/fusions-${1}-${5}-${6}-${4}-selfalign.tsv \
  -d genomicSuperDups.txt \
  -o ${GENION_DIR}/fusions-${1}-${5}-${6}-${4}-genion-minsup-${10}.tsv
