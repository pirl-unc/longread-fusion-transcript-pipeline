#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=32g
#SBATCH -n 1
#SBATCH -t 02:00:00

#for j in $(seq 1 10); do
/home/vantwisk/art_bin_MountRainier/art_illumina --rndSeed $RANDOM -ss HS25 -i ../Homo_sapiens.cdna_50k.fusion_transcripts_3.fasta -o i_hun/Homo_sapiens_coverage-${3}-length-${2}-${4}- -l $2 -f $3 -p -m 500 -s 10
#done
