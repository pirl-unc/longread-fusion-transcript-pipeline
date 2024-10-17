
for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!QUALITY[@]}; do
      for k in ${!TECH[@]}; do
        for n in ${!N_TRANSCRIPTS[@]}; do
           eval ${TF_BASH} fusionseeker_helper.sh ${COVERAGE[$q]} 1 1 ${i} ${QUALITY[$j]} ${TECH[$k]} ax sam ${MIN_OVERLAP_LEN} ${BIN_SIZE} ${MIN_MAP_LENGTH} ${N_TRANSCRIPTS[$n]}
        done
      done
    done
  done
done
