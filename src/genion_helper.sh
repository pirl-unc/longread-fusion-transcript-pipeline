#!/bin/bash
#SBATCH --job-name genion
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR=${SIM_STORAGE_DIR}/longreads_${10}k
DATADIR_MINIMAP=${ALIGNMENT_STORAGE_DIR}/longreads_${10}k_minimap2
GENION_DIR=${GENION_STORAGE_DIR}/longreads_${10}k_genion

[ ! -d ${GENION_DIR} ] && mkdir ${GENION_DIR}

echo ${1}
echo ${2}
echo ${3}
echo ${4}
echo ${5}
echo ${6}
echo ${7}
echo ${8}
echo ${9}
echo ${10}
echo $DATADIR/fusions-$1-$5-$6-$4.fq
echo $DATADIR_MINIMAP/fusions-${1}-${5}-${6}-${4}.paf
echo $GENION_DIR/fusions-$1-$5-$6-$4-genion-minsup-${9}.tsv

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
genion \
  -i ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq \
  --gtf ${GTF_REFERENCE_ENS} \
  --gpaf ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.paf \
  -s ${GENSELF} \
  -d ${GENOMIC_SUPER_DUPS} \
  -o ${GENION_DIR}/fusions-${1}-${5}-${6}-${4}-genion-minsup-${9}.tsv \
  --min-support ${9}
