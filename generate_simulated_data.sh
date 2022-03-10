
TRANSCRIPTOME=Homo_sapiens.cdna_50k.fa
FUSE_TRANSCRIPTS=test_fusions1.fa
FUSE_TRANSCRIPTOME=test_transcriptome.fa
FUSE_META=test_fusions1.txt
NFUSIONS=500

REPLICATES=10
COVERAGE=(3 5 10 30 50)
QUALITY=('87,97,5')   #('75,90,8' '87.5,97.5,5'  '95,100,4')
TECH=('pacbio2016' 'nanopore2020')

READ_LENGTHS=(100 150)

module load R-4.0.3

#Rscript split_transcripts.R ${TRANSCRIPTOME} ${FUSE_TRANSCRIPTS} ${FUSE_META} ${NFUSIONS}

#cp ${TRANSCRIPTOME} ${FUSE_TRANSCRIPTOME}
#cat ${FUSE_TRANSCRIPTS} >> ${FUSE_TRANSCRIPTOME}

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
        sbatch badread_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ${FUSE_TRANSCRIPTOME} 
      done
    done
  done
done


for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!READ_LENGTHS[@]}; do
      sbatch art_helper.sh ${COVERAGE[$q]} ${READ_LENGTHS[$j]} ${FUSE_TRANSCRIPTOME} ${i}
    done
  done
done
