#!/bin/sh

#SBATCH --job-name star
#SBATCH --partition allnodes
#SBATCH --time 12:00:00
#SBATCH --mem=128G

DATADIR=/datastore/scratch/users/vantwisk/sim/shortreads_training${6}k
MAPPING_DIR=/datastore/scratch/users/vantwisk/sim/shortreads_training${6}k_mapping

[ ! -d ${MAPPING_DIR} ] && mkdir ${MAPPING_DIR}

#for j in $(seq 1 10); do
#singularity exec --pid --bind /datastore star_latest.sif \
/home/vantwisk/STAR-2.7.10a/bin/Linux_x86_64_static/STAR \
    --runThreadN 16 \
    --genomeDir ../hg38_star_index --genomeLoad NoSharedMemory \
    --readFilesIn ${DATADIR}/fusions-${1}-${4}-${5}-1.fq ${DATADIR}/fusions-${1}-${4}-${5}-2.fq \
    --outFileNamePrefix ${MAPPING_DIR}/fusions-${1}-${4}-${5}- \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outBAMcompression 0 \
    --chimOutType WithinBAM \
          --chimSegmentMin 12 \
          --chimJunctionOverhangMin 8 \
          --chimOutJunctionFormat 1 \
          --alignSJDBoverhangMin 10 \
          --alignMatesGapMax 100000 \
          --alignIntronMax 100000 \
          --alignSJstitchMismatchNmax 5 -1 5 5 \
          --outSAMattrRGline ID:GRPundef \
          --chimMultimapScoreRange 3 \
          --chimScoreJunctionNonGTAG -4 \
          --chimMultimapNmax 20 \
          --chimNonchimScoreDropMin 10 \
          --peOverlapNbasesMin 12 \
          --peOverlapMMp 0.1 \
          --alignInsertionFlush Right \
          --alignSplicedMateMapLminOverLmate 0 \
          --alignSplicedMateMapLmin 30
#  STAR --runThreadN 8 \
#  --genomeDir hg38_star_index \
#  --readFilesIn i_hun/Homo_sapiens_coverage-${3}-length-${2}-${4}-1.fq i_hun/Homo_sapiens_coverage-${3}-length-${2}-${4}-2.fq \
#  --outFileNamePrefix i_hun/Star_Homo_sapiens_coverage-${3}-length-${2}-${4} \
#  --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outBAMcompression 0 --outSAMattributes Standard \
#  --outFilterMultimapNmax 50 --peOverlapNbasesMin 10 --alignSplicedMateMapLminOverLmate 0.5 --alignSJstitchMismatchNmax 5 -1 5 5 \
#  --chimOutType SeparateSAMold 
#  --chimSegmentMin 10 --chimOutType Junctions --chimJunctionOverhangMin 10 --chimScoreDropMax 30 \
#  --chimScoreJunctionNonGTAG 0 --chimScoreSeparation 1 --chimSegmentReadGapMax 3 --chimMultimapNmax 50
#done
