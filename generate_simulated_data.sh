N_TRANSCRIPTS=('1') #('1' '2' '4' '8' '16')
REPLICATES=1 #10
COVERAGE=(10) #(3 5 10 30 50 100)
QUALITY=('95,100,4')  #('75,90,8' '87,97,5'  '95,100,4')
TECH=('pacbio2016' 'nanopore2020')
READ_LENGTHS=(100 150)

## LONGGF OPTIONS
MIN_OVERLAP_LEN=100
BIN_SIZE=50
MIN_MAP_LENGTH=100

## JAFFAL OPTIONS

## GENION OPTIONS
GENION_MIN_SUPPORT=2

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
	 for n in ${!N_TRANSCRIPTS[@]}; do
           eval ${TF_BASH} badread_helper.sh ${COVERAGE[$q]} ${QUALITY_FILENAME[$j]} 1 ${i} ${QUALITY[$j]} ${TECH[$k]} training${N_TRANSCRIPTS[$n]}k_transcriptome.fa ${N_TRANSCRIPTS[$n]}
	 done
      done
    done
  done
done


for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!READ_LENGTHS[@]}; do
      for n in ${!N_TRANSCRIPTS[@]}; do
        eval ${TF_BASH} art_helper.sh ${COVERAGE[$q]} ${READ_LENGTHS[$j]} training${N_TRANSCRIPTS[$n]}k_transcriptome.fa ${i} ${N_TRANSCRIPTS[$n]}
      done
    done
  done
done
