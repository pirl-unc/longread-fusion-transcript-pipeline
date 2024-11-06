#!/bin/sh

#SBATCH --job-name arriba_helper
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH --mem=128G

MAPPING_DIR=${ALIGNMENT_STORAGE_DIR}/shortreads_${6}k_star
ARRIBA_DIR=${ARRIBA_STORAGE_DIR}/shortreads_${6}k_arriba

[ ! -d ${ARRIBA_DIR} ] && mkdir ${ARRIBA_DIR}

arriba \
    -x ${MAPPING_DIR}/fusions-${1}-${4}-${5}-Aligned.out.bam \
    -o ${ARRIBA_DIR}/fusions-${1}-${4}-${5}.tsv -O ${ARRIBA_DIR}/fusions-${1}-${4}-${5}.discarded.tsv \
    -a ${DNA_REFERENCE} \
    -g ${GTF_REFERENCE} \
    -b /home/vantwisk/arriba_v2.2.1/database/blacklist_hg38_GRCh38_v2.2.1.tsv \
    -k /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv \
    -t /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv \
    -p /home/vantwisk/arriba_v2.2.1/database/protein_domains_hg38_GRCh38_v2.2.1.gff3
