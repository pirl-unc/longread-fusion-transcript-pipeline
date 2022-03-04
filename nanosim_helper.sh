#!/bin/bash
#SBATCH --job-name nanosim
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --mem=128g

singularity exec --pid --bind /datastore nanosim_latest.sif \
  simulator.py transcriptome \
  -t 32 \
  -rt ../Homo_sapiens.cdna_50k.fusion_transcripts_3.fasta \
  -e /home/vantwisk/nanosim/pre-trained_models/human_NA12878_cDNA_Bham1_guppy/expression_abundance_fusions3.tsv \
  -c /home/vantwisk/nanosim/pre-trained_models/human_NA12878_cDNA_Bham1_guppy/training \
  -k 6 \
  --no_model_ir \
  --basecaller guppy \
  --fastq \
  --perfect \
  -r dRNA \
  -o hun2/fuse-$1-$2 \
  -n $1
