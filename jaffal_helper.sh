#!/bin/bash
#SBATCH --job-name jaffal
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

DATADIR=nfun-med
OUTDIR=${DATADIR}/fuse-${1}_jaffal_out

if [[ ! -d "${OUTDIR}" ]]
then
	mkdir ${OUTDIR}
fi
cd ${OUTDIR}

#singularity exec --pid --bind /datastore longgf_0.1.2--h05f6578_1.sif \
  ~/JAFFA-version-2.2/tools/bin/bpipe run ~/JAFFA-version-2.2/JAFFAL.groovy \
  ../../${DATADIR}/fuse-${1}-*.fq.gz
