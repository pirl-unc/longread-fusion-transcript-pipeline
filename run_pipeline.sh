
DATADIR=pfun-med
COVERAGE=50
REPLICATES=10

Rscript split_transcripts.R

bash badread.sh ${COVERAGE} 1 1 ${REPLICATES}
bash fqc.sh ${COVERAGE} 1 1 ${REPLCIATES}
bash minimap2.sh ${COVERAGE} 1 1 ${REPLICATES}
bash minimap2_paf.sh ${COVERAGE} 1 1 ${REPLICATES}
bash genself.sh ${COVERAGE} 1 1 ${REPLICATES}
bash sort.sh ${COVERAGE} 1 1 ${REPLICATES}
bash longread.sh ${COVERAGE} 1 1 ${REPLICATES}
bash genion.sh ${COVERAGE} 1 1 ${REPLICATES}
bash jaffal.sh ${COVERAGE} 1 1 ${REPLICATES}

Rscript generate_figures
