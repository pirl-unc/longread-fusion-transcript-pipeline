#!/bin/sh

#SBATCH --job-name starfusion
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH --mem=128G

micromamba activate starfusion

DATADIR=${SIM_STORAGE_DIR}/shortreads_${6}k
STARFUSION_DIR=${STARFUSION_STORAGE_DIR}/shortreads_${6}k

[ ! -d ${STARFUSION_DIR} ] && mkdir ${STARFUSION_DIR}

STAR-Fusion --genome_lib_dir ${CTAT_LIB_DIR}/ctat_genome_lib_build_dir \
	--left_fq ${DATADIR}/fusions-${1}-${4}-${5}-1.fq \
	--right_fq ${DATADIR}/fusions-${1}-${4}-${5}-2.fq \
	--output_dir ${STARFUSION_DIR}/fusions-${1}-${4}-${5}

micromamba deactivate starfusion
