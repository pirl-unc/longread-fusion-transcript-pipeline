
TRANSCRIPTOME=Homo_sapiens.cdna_50k.fa
FUSE_TRANSCRIPTS=test_fusions1.fa
FUSE_TRANSCRIPTOME=test_transcriptome.fa
FUSE_META=test_fusions1.txt
NFUSIONS=500

REPLICATES=10
COVERAGE=(3 5 10 30 50)
QUALITY=('87,97,5' '75,90,8' '95,100,4')
TECH=('pacbio2016' 'nanopore2020')

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
        sbatch run_longgf_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ${FUSE_TRANSCRIPTOME} 
      done
    done
  done
done
