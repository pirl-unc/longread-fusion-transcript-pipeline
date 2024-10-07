#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH -t 12:00:00

DATADIR=/datastore/scratch/users/vantwisk/sim/longreads_training${9}k
DATADIR_MINIMAP=/datastore/scratch/users/vantwisk/sim/longreads_training${9}k_minimap2

[ ! -d ${DATADIR_MINIMAP} ] && mkdir ${DATADIR_MINIMAP}

echo $1 #coverage
echo $2 #nothing
echo $3 #nothing
echo $4 #run
echo $5 #identity
echo $6 #tech
echo $7 #ax
echo $8 #sam
echo $9 #n

#for j in $(seq 1 10); do
#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -cx ava-ont ${DATADIR}/fuse-${1}-${4}.fq.gz ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR}/fuse-${1}-${4}-minimap2-splice.paf
/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -t 32 --MD -${7} splice ../hg38.fa ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz > ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.${8}
#done

samtools view ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.sam -o ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.bam
samtools sort ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.bam -o ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-sorted.bam
samtools sort -n ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}.bam -o ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-n-sorted.bam
