#!/bin/sh

#SBATCH --job-name star
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH --mem=128G

micromamba activate arriba

ulimit -S -n 4096

DATADIR=${SIM_STORAGE_DIR}/shortreads_${6}k
MAPPING_DIR=${ALIGNMENT_STORAGE_DIR}/shortreads_${6}k_star

[ ! -d ${MAPPING_DIR} ] && mkdir ${MAPPING_DIR}

STAR \
    --runThreadN ${THREADS} \
    --genomeDir ${STAR_INDEX_STORAGE_DIR} --genomeLoad NoSharedMemory \
    --readFilesIn ${DATADIR}/fusions-${1}-${4}-${5}-1.fq ${DATADIR}/fusions-${1}-${4}-${5}-2.fq \
    --outFileNamePrefix ${MAPPING_DIR}/fusions-${1}-${4}-${5}- \
    --outSAMtype BAM Unsorted --outSAMunmapped Within --outBAMcompression 0 \
    	--outFilterMultimapNmax 50 \
   	--peOverlapNbasesMin 10 \
    	--alignSplicedMateMapLminOverLmate 0.5 \
    	--alignSJstitchMismatchNmax 5 -1 5 5 \
    	--chimSegmentMin 10 \
    	--chimOutType WithinBAM HardClip \
    	--chimJunctionOverhangMin 10 \
    	--chimScoreDropMax 30 \
    	--chimScoreJunctionNonGTAG 0 \
    	--chimScoreSeparation 1 \
    	--chimSegmentReadGapMax 3 \
    	--chimMultimapNmax 50

micromamba deactivate arriba
