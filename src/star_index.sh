#!/bin/bash
#SBATCH --job-name star_index
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 128g

#singularity exec --pid --bind /datastore star_latest.sif \
STAR \
  --runThreadN ${THREADS} \
  --runMode genomeGenerate \
  --genomeDir ${DNA_REFERENCE}_index \
  --genomeFastaFiles ${DNA_REFERENCE} \
  --sjdbGTFfile ${GTF_REFERENCE}

