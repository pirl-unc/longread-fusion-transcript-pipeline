
DATADIR=pfun-med
COVERAGE=50
REPLICATES=10

bash generate_annotation_resources.sh
bash generate_breakpoints.sh
bash generate_simulated_data.sh
bash generate_mapping.sh
bash generate_arriba.sh
bash generate_longgf.sh
bash generate_jaffal.sh
bash generate_genion.sh
bash generate_fusionseeker.sh
bash generate_pbfusion.sh

Rscript generate_figures.R
