#!/bin/bash
#SBATCH --job-name jaffal
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR=/datastore/scratch/users/vantwisk/sim/longreads_training${9}k
JAFFAL_DATADIR=/datastore/scratch/users/vantwisk/sim/longreads${9}k_training_jaffal
#JAFFAL_DATADIR=/datastore/scratch/users/vantwisk/sim/longreads1k_training_jaffal
OUTDIR=${JAFFAL_DATADIR}/fusions-${1}-${5}-${6}-${4}-jaffal_out
#OUTDIR=${JAFFAL_DATADIR}/fusions-${1}-${5}-${6}-${4}-jaffal_out

[ ! -d ${JAFFAL_DATADIR} ] && mkdir ${JAFFAL_DATADIR}

[ ! -d ${OUTDIR} ] && mkdir ${OUTDIR}

cd ${OUTDIR}

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
echo ${DATADIR}/fusions-${1}-${5}-${6}-*.fq.gz
~/JAFFA-version-2.2/tools/bin/bpipe run ~/JAFFA-version-2.2/JAFFAL.groovy \
  ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq.gz
