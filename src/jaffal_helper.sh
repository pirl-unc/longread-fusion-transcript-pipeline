#!/bin/bash
#SBATCH --job-name jaffal
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

JAFFAL_QUALITY_NAME=`sed "s/,/_/g" <<< "${5}"`

DATADIR=${SIM_STORAGE_DIR}/longreads_${9}k
JAFFAL_DATADIR=${JAFFAL_STORAGE_DIR}/longreads_${9}k_jaffal
OUTDIR=${JAFFAL_DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-${4}-jaffal_out

[ ! -d ${JAFFAL_DATADIR} ] && mkdir ${JAFFAL_DATADIR}

[ ! -d ${OUTDIR} ] && mkdir ${OUTDIR}

CURRENT=`pwd`

cd ${OUTDIR}

for i in $(seq 1 ${REPLICATES}); do
  cp ${DATADIR}/fusions-${1}-${5}-${6}-${i}.fq.gz ${DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-${i}.fq.gz
done

/ref/tools/bin/bpipe run /ref/JAFFAL.groovy \
  ${DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-${4}.fq.gz

cd $CURRENT
