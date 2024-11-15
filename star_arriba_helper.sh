#!/bin/sh

#SBATCH --job-name star_arriba
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem=128G

ulimit -S -n 4096

DATADIR=${SIM_STORAGE_DIR}/shortreads_${6}k
MAPPING_DIR=${ALIGNMENT_STORAGE_DIR}/shortreads_${6}k_star
ARRIBA_DIR=${ARRIBA_STORAGE_DIR}/shortreads_${6}k_arriba

[ ! -d ${MAPPING_DIR} ] && mkdir ${MAPPING_DIR}
[ ! -d ${ARRIBA_DIR} ] && mkdir ${ARRIBA_DIR}

/home/vantwisk/STAR-2.7.10a/bin/Linux_x86_64_static/STAR \
    --runThreadN ${THREADS} \
    --genomeDir ${STAR_INDEX_STORAGE_DIR} --genomeLoad NoSharedMemory \
    --readFilesIn ${DATADIR}/fusions-${1}-${4}-${5}-1.fq ${DATADIR}/fusions-${1}-${4}-${5}-2.fq \
    --outTmpDir ${MAPPING_DIR}/fusions-${1}-${4}-${5}-temp \
    --outStd BAM_Unsorted \
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
    	--chimMultimapNmax 50 |
/home/vantwisk/arriba_v2.2.1/arriba \
	-x /dev/stdin \
	-o ${ARRIBA_DIR}/fusions-${1}-${4}-${5}.tsv -O ${ARRIBA_DIR}/fusions-${1}-${4}-${5}.discarded.tsv \
	-a ${DNA_REFERENCE_ENS} \
	-g ${GTF_REFERENCE_ENS} \
	-b /home/vantwisk/arriba_v2.2.1/database/blacklist_hg38_GRCh38_v2.2.1.tsv \
	-k /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv \
	-t /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv \
	-p /home/vantwisk/arriba_v2.2.1/database/protein_domains_hg38_GRCh38_v2.2.1.gff3


