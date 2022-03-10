#!/bin/bash
#SBATCH --job-name longgf
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 128G

MINIMAP_DIR=longreads_mappings
LONGGF_DIR=longreads_longgf

if [ ! -f ${MINIMAP_DIR}/fusions-${1}-${5}-${6}-${4}.sam ]; then
    bash minimap2_helper.sh ${1} ${2} ${3} ${4} ${5} ${6} ax sam
fi

if [ ! -f ${MINIMAP_DIR}/fusions-${1}-${5}-${6}-${4}-sorted.bam ]; then
    bash sort_helper.sh ${1} ${2} ${3} ${4} ${5} ${6} '-n'
fi

#if [ ! -f ${LONGGF_DIR}/fusions-${1}-${4}-sorted-minimap2-splice-ax-n.log ]; then
bash longgf_helper.sh $1 $2 $3 $4 $5 $6
#fi
