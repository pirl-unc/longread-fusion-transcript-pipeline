#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH -t 12:00:00


#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -cx ava-ont ${DATADIR}/fuse-${1}-${4}.fq.gz ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR_MINIMAP}/fuse-${1}-${4}-minimap2-splice.paf
/home/vantwisk/minimap2-2.21_x64-linux/minimap2 $CDNA_REFERENCE $CDNA_REFERENCE -X -t $THREADS -2 -c -o $REF_STORAGE_DIR/genion-selfalign.paf
cat $REF_STORAGE_DIR/genion-selfalign.paf | cut -f1,6 | sed 's/_/\t/g' | awk 'BEGIN{OFS="\t";}{print substr($1,1,15),substr($2,1,15),substr($3,1,15),substr($4,1,15);}' | awk '$1!=$3' | sort | uniq > $GENSELF
#/home/vantwisk/minimap2-2.21_x64-linux/minimap2 -t 32 --MD -cx splice ../hg38.fa ${DATADIR}/fuse-${1}-${4}.fq.gz > ${DATADIR_MINIMAP}/fuse-${1}-${4}-minimap2-splice.paf
#done
