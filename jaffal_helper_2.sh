#!/bin/bash
#SBATCH --job-name jaffal
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

JAFFAL_QUALITY_NAME=`sed "s/,/_/g" <<< "${5}"`
#JAFFAL_QUALITY_NAME=${5}

DATADIR=${SIM_STORAGE_DIR}/longreads_${9}k
JAFFAL_DATADIR=${JAFFAL_STORAGE_DIR}/longreads_${9}k_jaffal
OUTDIR=${JAFFAL_DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-jaffal_out

[ ! -d ${JAFFAL_DATADIR} ] && mkdir ${JAFFAL_DATADIR}

[ ! -d ${OUTDIR} ] && mkdir ${OUTDIR}

CURRENT=`pwd`

cd ${OUTDIR}

for i in $(seq 1 ${REPLICATES}); do
  ln -sf ${DATADIR}/fusions-${1}-${5}-${6}-${i}.fq.gz ${DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-${i}.fq.gz
done

#[ ! -d ${DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-${4}.fq.gz ] && cat ${DATADIR}/fusions-${1}-${5}-${6}-${4}.fq | gzip ${DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-${4}.fq.gz

~/JAFFA-version-2.2/tools/bin/bpipe run ~/JAFFA-version-2.2/JAFFAL.groovy \
  ${DATADIR}/fusions-${1}-${JAFFAL_QUALITY_NAME}-${6}-*.fq.gz

cd $CURRENT
