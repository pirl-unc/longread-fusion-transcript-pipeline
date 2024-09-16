#!/bin/sh

#SBATCH -N 1
#SBATCH --mem=32g
#SBATCH -n 1
#SBATCH -t 02:00:00


OUTDIR=shortreads
[ ! -d ${OUTDIR} ] && mkdir ${OUTDIR}

echo $1
echo $2
echo $3
echo $4

#for j in $(seq 1 10); do
/home/vantwisk/art_bin_MountRainier/art_illumina --rndSeed $RANDOM -ss HS25 -i ${3} -o ${OUTDIR}/fusions-${1}-${2}-${4}- -l ${2} -f ${4} -p -m 500 -s 10
#done
