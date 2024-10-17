#!/bin/bash
#SBATCH --job-name pbmm2-index
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem=128G

pbmm2 index ${DNA_REFERENCE} ${PBMM2_MMI}
