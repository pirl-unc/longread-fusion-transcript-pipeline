
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

READ_LENGTHS=(100 150)

#module load R-4.0.3

#Rscript split_transcripts.R ${TRANSCRIPTOME} ${FUSE_TRANSCRIPTS} ${FUSE_META} ${NFUSIONS}

#cp ${TRANSCRIPTOME} ${FUSE_TRANSCRIPTOME}
#cat ${FUSE_TRANSCRIPTS} >> ${FUSE_TRANSCRIPTOME}

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
	 for n in ${!N_TRANSCRIPTS[@]}; do
           sbatch badread_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} training${N_TRANSCRIPTS[$n]}k_transcriptome.fa ${N_TRANSCRIPTS[$n]}
	 done
      done
    done
  done
done


#for i in $(seq 1 ${REPLICATES}); do
#  for q in ${!COVERAGE[@]}; do
#    for j in ${!READ_LENGTHS[@]}; do
#      for n in ${!N_TRANSCRIPTS[@]}; do
#        sbatch art_helper.sh ${COVERAGE[$q]} ${READ_LENGTHS[$j]} training${N_TRANSCRIPTS[$n]}k_transcriptome.fa ${i} ${N_TRANSCRIPTS[$n]}
#      done
#    done
#  done
#done
