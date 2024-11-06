N_TRANSCRIPTS=("canoncical") #REPLACE_N_TRANSCRIPTS
REPLICATES=1 #REPLACE_REPLICATES
COVERAGE=(3 4 5) #REPLACE_COVERAGE
QUALITY=("95,100,4") #REPLACE_QUALITY
TECH=("pacbio2021" "nanopore2023") #REPLACE_TECH
READ_LENGTHS=(150) #REPLACE_READ_LENGTHS

					## LONGGF OPTIONS
					MIN_OVERLAP_LEN=100 # REPLACE_MIN_OVERLAP_LEN
					BIN_SIZE=50 # REPLACE_BIN_SIZE
MIN_MAP_LENGTH=100 #REPLACE_MIN_MAP_LENGTH

					## JAFFAL OPTIONS

					## GENION OPTIONS
GENION_MIN_SUPPORT=2 #REPLACE_GENION_MIN_SUPPORT

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
	 for n in ${!N_TRANSCRIPTS[@]}; do
           eval ${TF_BASH} $DOCKER_SRC/minimap2_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ax sam ${N_TRANSCRIPTS[$n]}
	 done
      done
    done
  done
done

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
	 for n in ${!N_TRANSCRIPTS[@]}; do
           eval ${TF_BASH} $DOCKER_SRC/minimap2_paf_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ax paf ${N_TRANSCRIPTS[$n]}
	 done
      done
    done
  done
done

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
	 for n in ${!N_TRANSCRIPTS[@]}; do
           eval ${TF_BASH} $DOCKER_SRC/pbmm2_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ax sam ${N_TRANSCRIPTS[$n]}
	 done
      done
    done
  done
done

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!READ_LENGTHS[@]}; do
      for n in ${!N_TRANSCRIPTS[@]}; do
        eval ${TF_BASH} $DOCKER_SRC/star_helper2.sh ${COVERAGE[$q]} 1 1 ${READ_LENGTHS[$j]} ${i} ${N_TRANSCRIPTS[$n]}
      done
    done
  done
done
