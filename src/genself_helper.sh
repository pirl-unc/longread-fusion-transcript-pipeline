#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH -t 04:00:00

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
echo $8 #sam
echo $9 #n

#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -cx ava-ont ${DATADIR}/fuse-${1}-${4}.fq.gz ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR_MINIMAP}/fuse-${1}-${4}-minimap2-splice.paf
/home/vantwisk/minimap2-2.21_x64-linux/minimap2 ${CDNA_REFERENCE} ${CDNA_REFERENCE} -X -t ${THREADS} -2 -c -o ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-selfalign.paf
cat ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-selfalign.paf | cut -f1,6 | sed 's/_/\t/g' | awk 'BEGIN{OFS="\t";}{print substr($1,1,15),substr($2,1,15),substr($3,1,15),substr($4,1,15);}' | awk '$1!=$3' | sort | uniq > ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-selfalign.tsv
#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -t 32 --MD -cx splice ../hg38.fa ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR_MINIMAP}/fuse-${1}-${4}-minimap2-splice.paf
#done
