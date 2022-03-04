#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH -t 04:00:00

DATADIR=pfun-med

#for j in $(seq 1 10); do
#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -cx ava-ont ${DATADIR}/fuse-${1}-${4}.fq.gz ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR}/fuse-${1}-${4}-minimap2-splice.paf
/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -t 32 -ax splice ../hg38.fa ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR}/fuse-${1}-${4}-minimap2-splice.paf
#done
