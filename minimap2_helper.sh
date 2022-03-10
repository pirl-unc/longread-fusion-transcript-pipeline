#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH -t 12:00:00

DATADIR=longreads
DATADIR_MINIMAP=longreads_mappings

echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo $7
echo $8

#for j in $(seq 1 10); do
#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -cx ava-ont ${DATADIR}/fuse-${1}-${4}.fq.gz ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR}/fuse-${1}-${4}-minimap2-splice.paf
/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -t 32 --MD -${7} splice ../hg38.fa ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz > ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.${8}
#done
