
for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!READ_LENGTHS[@]}; do
      for n in ${!N_TRANSCRIPTS[@]}; do
        eval ${TF_BASH} arriba_helper.sh ${COVERAGE[$q]} 1 1 ${READ_LENGTHS[$j]} ${i} ${N_TRANSCRIPTS[$n]}
      done
    done
  done
done
