#!/bin/sh

#SBATCH --job-name arriba_helper
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH --mem=128G

#for j in $(seq 1 10); do
#singularity exec --pid --bind /datastore arriba_latest.sif \
/home/vantwisk/arriba_v2.2.1/arriba \
    -x i_hun/Star_Homo_sapiens_coverage-${3}-length-${2}-${4}Aligned.sortedByCoord.out.bam \
    -o i_hun/Star_Homo_sapiens_coverage-${3}-length-${2}-${4}.tsv -O i_hun/Star_Homo_sapiens_coverage-${3}-length-${2}-${4}.discarded.tsv \
    -a Homo_sapiens.GRCh38.dna.primary_assembly.fa -g Homo_sapiens.GRCh38.105.chr.gtf \
    -b /home/vantwisk/arriba_v2.2.1/database/blacklist_hg38_GRCh38_v2.2.1.tsv -k /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv -t /home/vantwisk/arriba_v2.2.1/database/known_fusions_hg38_GRCh38_v2.2.1.tsv -p /home/vantwisk/arriba_v2.2.1/database/protein_domains_hg38_GRCh38_v2.2.1.gff3
#done
