#!/bin/sh

#SBATCH --job-name arriba_helper
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH --mem=128G

DATADIR=/datastore/scratch/users/vantwisk/sim/shortreads_training${6}k
MAPPING_DIR=/datastore/scratch/users/vantwisk/sim/shortreads_training${6}k_mapping
ARRIBA_DIR=/datastore/scratch/users/vantwisk/sim/shortreads_training${6}k_arriba

[ ! -d ${ARRIBA_DIR} ] && mkdir ${ARRIBA_DIR}

#for j in $(seq 1 10); do
#singularity exec --pid --bind /datastore arriba_latest.sif \
/home/vantwisk/arriba_v2.2.1/arriba \
    -x ${MAPPING_DIR}/fusions-${1}-${4}-${5}-Aligned.sortedByCoord.out.bam \
    -o ${ARRIBA_DIR}/fusions-${1}-${4}-${5}.tsv -O ${ARRIBA_DIR}/fusions-${1}-${4}-${5}.discarded.tsv \
    -a Homo_sapiens.GRCh38.dna.primary_assembly.fa -g Homo_sapiens.GRCh38.105.chr.gtf \
    -b /home/vantwisk/arriba_v2.2.1/database/blacklist_hg38_GRCh38_v2.2.1.tsv -k /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv -t /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv -p /home/vantwisk/arriba_v2.2.1/database/protein_domains_hg38_GRCh38_v2.2.1.gff3
#done
