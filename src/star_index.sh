#!/bin/bash
#SBATCH --job-name star_index
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 128g

eval "$(micromamba shell init -s bash)"
micromamba activate arriba

#singularity exec --pid --bind /datastore star_latest.sif \
/home/vantwisk/STAR-2.7.10a/bin/Linux_x86_64_static/STAR \
  --runThreadN ${THREADS} \
  --runMode genomeGenerate \
  --genomeDir ${DNA_REFERENCE}_index \
  --genomeFastaFiles ${DNA_REFERENCE} \
  --sjdbGTFfile ${GTF_REFERENCE}

micromamba deactivate
