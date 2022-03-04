#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH --time 24:00:00

#for j in $(seq 1 10); do
rustyread --threads 32 simulate --reference ../100_sample10.fa \
    --quantity ${1}x \
    --qscore_model pacbio2016 --glitches 0,0,0 --junk_reads 0 --random_reads 0 \
    --error_model pacbio2016 --identity 95,100,4 \
    --chimera 0 --seed $RANDOM | gzip > test10.fq.gz #pfun/fuse-${1}-${4}.fq.gz  #fuse-transcript-${1}-${4}.fq.gz
#done
