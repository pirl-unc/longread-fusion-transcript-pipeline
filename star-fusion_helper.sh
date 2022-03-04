#!/bin/bash
#SBATCH --job-name star-fusion
#SBATCH --partition allnodes
#SBATCH --time UNLIMITED
#SBATCH --mem 128g


singularity exec --pid --bind /datastore /home/vantwisk/STAR-Fusion/Docker/star-fusion.v1.10.1.simg \
  STAR-Fusion \
  --CPU 32 \
  --output_dir i_hun/Homo_sapiens_coverage-${3}-length-${2}-${4}_starfusion_output \
  --left_fq i_hun/Homo_sapiens_coverage-${3}-length-${2}-${4}-1.fq \
  --right_fq i_hun/Homo_sapiens_coverage-${3}-length-${2}-${4}-2.fq \
  --genome_lib_dir GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir
  #-J i_hun/Star_Homo_sapiens_coverage-${3}-length-${2}-${4}Chimeric.out.junction \
  #--genome_lib_dir GRCh38_gencode_v31_CTAT_lib_Aug152019.source \
