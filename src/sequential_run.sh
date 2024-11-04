
DOCKER_SRC=/src

source $DOCKER_SRC/environment.config $1

bash $DOCKER_SRC/generate_annotation_resources.sh
bash $DOCKER_SRC/generate_fusim.sh

bash $DOCKER_SRC/generate_simulated_data.sh

#eval ${TF_BASH} $DOCKER_SRC/pbmm2_index.sh
#eval ${TF_BASH} $DOCKER_SRC/star_index.sh
#eval ${TF_BASH} $DOCKER_SRC/genself.sh

#bash $DOCKER_SRC/generate_mapping.sh

#bash $DOCKER_SRC/generate_longgf.sh
#bash $DOCKER_SRC/generate_jaffal.sh
#bash $DOCKER_SRC/generate_genion.sh
#bash $DOCKER_SRC/generate_pbfusion.sh
#bash $DOCKER_SRC/generate_fusionseeker.sh

#bash $DOCKER_SRC/generate_arriba.sh
#bash $DOCKER_SRC/generate_starfusion.sh

#bash $DOCKER_SRC/generate_graphs.sh
