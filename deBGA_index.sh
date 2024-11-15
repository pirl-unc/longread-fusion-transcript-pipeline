#!/bin/bash
#SBATCH --job-name deBGA-index
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 128g

#singularity exec --pid --bind /datastore star_latest.sif \
echo ${DNA_REFERENCE}
/home/vantwisk/deSALT/src/deBGA index -k 22 ${DNA_REFERENCE} ../../deBGA
