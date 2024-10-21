#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=128G
#SBATCH -n 1
#SBATCH --time 24:00:00

OUTDIR=${SIM_STORAGE_DIR}/longreads_${8}k

[ ! -d ${OUTDIR} ] && mkdir ${OUTDIR}
echo $1
echo $2
echo $3
echo $4
echo $5
echo $6
echo $7
echo $8

rustyread --threads 32 simulate --reference ${FUSION_TRANSCRIPTOME} \
    --quantity ${1}x \
    --qscore_model /home/vantwisk/Badread/badread/qscore_models/${6} --glitches 0,0,0 --junk_reads 0 --random_reads 0 \
    --error_model /home/vantwisk/Badread/badread/error_models/${6} --identity ${5} \
    --chimera 0 --seed $RANDOM > ${OUTDIR}/fusions-${1}-${5}-${6}-${4}.fq #pfun/fuse-${1}-${4}.fq.gz  #fuse-transcript-${1}-${4}.fq.gz

awk '{ if (NR%4==1) gsub(".*","@transcript/"NR,$1); print }' ${OUTDIR}/fusions-${1}-${5}-${6}-${4}.fq > ${OUTDIR}/fusions-${1}-${5}-${6}-${4}_2.fq
mv ${OUTDIR}/fusions-${1}-${5}-${6}-${4}_2.fq ${OUTDIR}/fusions-${1}-${5}-${6}-${4}.fq
#awk '{ if (NR%4==1) gsub(".*","@transcript/"NR,$1); print }' ${OUTDIR}/fusions-${1}-${5}-${6}-${4}.fq > ${OUTDIR}/fusions-${1}-${5}-${6}-${4}.fq
