This repository is a collection of modules written in bash that are used to run the simulated longread fusion transcript detector.

The `src` directory contains files relevant to the pipeline. The pipeline is meant to be run in the asscociated docker image located at https://hub.docker.com/repository/docker/vantwisk/longread-fusion-transcript-pipeline/general.

The pipeline will produce the `ref`, `sim`, `alignments`, and `results` directories in the bound folder. The `results` directory contains the fusion results for the various tools as well as the output graphs in the `graphs` directory.

Files in the `ref` directory can be used for subsequent runs. Otherwise, the pipeline will populate it with needed resources to run the pipeline.
