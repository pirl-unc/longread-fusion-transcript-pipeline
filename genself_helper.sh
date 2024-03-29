#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH -t 04:00:00

DATADIR=longreads
MINIMAP_DATADIR=longreads-mappings

#for j in $(seq 1 10); do
#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -cx ava-ont ${DATADIR}/fuse-${1}-${4}.fq.gz ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR}/fuse-${1}-${4}-minimap2-splice.paf
/home/vantwisk/minimap2-2.21_x64-linux/minimap2 ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz -X -t 32 -2 -c -o ${MINIMAP_DATADIR}/fusions-${1}-${5}-${6}-${4}-selfalign.paf
cat ${MINIMAP_DATADIR}/fusions-${1}-${5}-${6}-${4}-selfalign.paf | cut -f1,6 | sed 's/_/\t/g' | awk 'BEGIN{OFS=\"\\t\";}{print substr($1,1,15),substr($2,1,15),substr($3,1,15),substr($4,1,15);}' | awk '$1!=$3' | sort | uniq > ${MINIMAP_DATADIR}/fusions-${1}-${5}-${6}-${4}-selfalign.tsv
#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -t 32 --MD -cx splice ../hg38.fa ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR}/fuse-${1}-${4}-minimap2-splice.paf
#done
