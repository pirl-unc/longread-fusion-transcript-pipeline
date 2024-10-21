N_TRANSCRIPTS=('1') #('1' '2' '4' '8' '16')
REPLICATES=1 #10
COVERAGE=(3 10) #(3 5 10 30 50 100)
QUALITY=('87,97,5' '95,100,4')  #('75,90,8' '87,97,5'  '95,100,4')
TECH=('pacbio2016' 'nanopore2020')
READ_LENGTHS=(100 150)

## LONGGF OPTIONS
MIN_OVERLAP_LEN=100
BIN_SIZE=50
MIN_MAP_LENGTH=100

## JAFFAL OPTIONS

## GENION OPTIONS
GENION_MIN_SUPPORT=1

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
        for n in ${!N_TRANSCRIPTS[@]}; do
           eval ${TF_BASH} genion_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ax sam ${GENION_MIN_SUPPORT} ${N_TRANSCRIPTS[$n]}
        done
      done
    done
  done
done
