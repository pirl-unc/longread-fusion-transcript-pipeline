#!/bin/bash
#SBATCH --job-name pbmm2
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR=/datastore/scratch/users/vantwisk/sim/longreads_training${9}k
DATADIR_MINIMAP=/datastore/scratch/users/vantwisk/sim/longreads_training${9}k_minimap2

[ ! -d ${DATADIR_MINIMAP} ] && mkdir ${DATADIR_MINIMAP}

pbmm2 align -j 32 --preset ISOSEQ --sort ../hg38_gencode.mmi ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz ${DATADIR_MINIMAP}/fusions-${1}-${5}-${6}-${4}-pbmm2.bam
