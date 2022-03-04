#!/bin/bash
#SBATCH --job-name SAMP1
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --cpus-per-task 1
#SBATCH --mem-per-cpu 128g

#singularity exec --pid --bind /datastore star_latest.sif \
/home/vantwisk/STAR-2.7.10a/bin/Linux_x86_64_static/STAR --runThreadN 32 \
  --runMode genomeGenerate \
  --genomeDir hg38_star_index \
  --genomeFastaFiles ../hg38.fa
  --sjdbGTFfile gencode.v38.annotation.gtf
