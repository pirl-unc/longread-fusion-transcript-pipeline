#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH -t 12:00:00

DATADIR=${SIM_STORAGE_DIR}/longreads_${9}k
DATADIR_MINIMAP=${ALIGNMENT_STORAGE_DIR}/longreads_${9}k_minimap2

[ ! -d ${DATADIR_MINIMAP} ] && mkdir ${DATADIR_MINIMAP}

echo $1 #coverage
echo $2 #nothing
echo $3 #nothing
echo $4 #run
echo $5 #identity
echo $6 #tech
echo $7 #ax
echo $8 #paf
echo $9 #n

minimap2 -t ${THREADS} --MD -cx splice ${DNA_REFERENCE_ENS} ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz > ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.${8}

