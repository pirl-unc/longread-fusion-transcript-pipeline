TRANSCRIPTOME=Homo_sapiens.GRCh38.105.cdna.gtf_confirmed_new_16k.fa
FUSE_TRANSCRIPTS=training16k_fusions.fa
FUSE_TRANSCRIPTOME=training16k_transcriptome.fa
FUSE_META=training16k_fusions.txt
NFUSIONS=100

N_TRANSCRIPTS=('1')
REPLICATES=10
COVERAGE=(3 5 10 30 50 100)
QUALITY=('75,90,8' '87,97,5'  '95,100,4')
TECH=('pacbio2016' 'nanopore2020')
MIN_OVERLAP_LEN=100
BIN_SIZE=50
MIN_MAP_LENGTH=100

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
        for n in ${!N_TRANSCRIPTS[@]}; do
           sbatch longgf_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ax sam ${MIN_OVERLAP_LEN} ${BIN_SIZE} ${MIN_MAP_LENGTH} ${N_TRANSCRIPTS[$n]}
        done
      done
    done
  done
done
