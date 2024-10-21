N_TRANSCRIPTS=('1') #('1' '2' '4' '8' '16')
REPLICATES=1 #10
COVERAGE=(3 10) #(3 5 10 30 50 100)
QUALITY=('87,97,5' '95,100,4')  #('75,90,8' '87,97,5'  '95,100,4')
TECH=('pacbio2016' 'nanopore2020')
READ_LENGTHS=(100 150)

for i in $(seq 1 ${REPLICATES}); do
  for q in ${!COVERAGE[@]}; do
    for j in ${!READ_LENGTHS[@]}; do
      for n in ${!N_TRANSCRIPTS[@]}; do
        sbatch arriba_helper.sh ${COVERAGE[$q]} 1 1 ${READ_LENGTHS[$j]} ${i} ${N_TRANSCRIPTS[$n]}
      done
    done
  done
done
