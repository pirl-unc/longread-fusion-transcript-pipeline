#!/bin/bash
#SBATCH --job-name gmap
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 128g

#singularity exec --pid --bind /datastore star_latest.sif \
singularity exec --pid --bind /datastore idp-fusion_latest.sif \
	gmap_build -d ./gmapindex ../hg38.fa
