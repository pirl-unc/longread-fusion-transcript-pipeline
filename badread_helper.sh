#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH --time 24:00:00

OUTDIR=longreads


[ ! -d ${OUTDIR} ] && mkdir ${OUTDIR}
echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo $7

#for j in $(seq 1 10); do
rustyread --threads 32 simulate --reference ${7} \
    --quantity ${1}x \
    --qscore_model ${6} --glitches 0,0,0 --junk_reads 0 --random_reads 0 \
    --error_model ${6} --identity ${5} \
    --chimera 0 --seed $RANDOM | gzip > ${OUTDIR}/fusions-${1}-${5}-${6}-${4}.fq.gz #pfun/fuse-${1}-${4}.fq.gz  #fuse-transcript-${1}-${4}.fq.gz
#done
