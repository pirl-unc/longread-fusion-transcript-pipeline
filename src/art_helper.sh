#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=32g
#SBATCH -n 1
#SBATCH -t 02:00:00


OUTDIR=${SIM_STORAGE_DIR}/shortreads_${6}k
[ ! -d ${OUTDIR} ] && mkdir ${OUTDIR}

echo $1
echo $2
echo $3
echo $4

#for j in $(seq 1 10); do
/bin/art_bin_MountRainier/art_illumina --rndSeed $RANDOM -ss HS25 -i ${FUSION_TRANSCRIPTOME} -o ${OUTDIR}/fusions-${1}-${4}-${5}- -l ${4} -f ${1} -p -m 500 -s 10
#done

#cat ${OUTDIR}/fusions-${1}-${4}-${5}-1.fq | gzip > ${OUTDIR}/fusions-${1}-${4}-${5}-1.fq.gz
#cat ${OUTDIR}/fusions-${1}-${4}-${5}-2.fq | gzip > ${OUTDIR}/fusions-${1}-${4}-${5}-2.fq.gz
