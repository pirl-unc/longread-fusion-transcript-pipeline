
#FROM quay.io/biocontainers/pbmm2:1.16.0--h9ee0642_0 AS Pbmm2
#FROM quay.io/biocontainers/pbfusion:0.3.1--hdfd78af_0 AS PBFusion
#FROM quay.io/biocontainers/longgf:0.1.2--h4ac6f70_7 AS LongGF
FROM davidsongroup/jaffa:2.4 AS JAFFA
#FROM quay.io/biocontainers/minimap2:2.28--he4a0461_2 AS Minimap2
#FROM quay.io/biocontainers/arriba:2.4.0--hdbdd923_4 AS Arriba
#FROM quay.io/biocontainers/star:2.7.11b--h43eeafb_2 AS Star
#FROM quay.io/biocontainers/genion:1.2.3--hdcf5f25_1 AS Genion
#FROM quay.io/biocontainers/star-fusion:1.10.0--hdfd78af_1 AS Starfusion
#FROM staphb/samtools:1.9 AS Samtools

FROM ubuntu:22.04 AS Fusim

WORKDIR /opt

RUN apt-get update && \
    apt-get install -y wget unzip git && \
    wget https://github.com/aebruno/fusim/raw/master/releases/fusim-0.2.2-bin.zip && \
    unzip fusim-0.2.2-bin.zip &&\
    wget https://www.niehs.nih.gov/sites/default/files/2024-02/artbinmountrainier2016.06.05linux64.tgz && \
    tar xvzf artbinmountrainier2016.06.05linux64.tgz && \
    git clone https://github.com/Maggi-Chen/FusionSeeker.git

FROM mambaorg/micromamba:2.0.2 AS envbuilder
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
COPY --chown=$MAMBA_USER:$MAMBA_USER env_a.yaml /tmp/env_a.yaml
COPY --chown=$MAMBA_USER:$MAMBA_USER env_b.yaml /tmp/env_b.yaml
COPY --chown=$MAMBA_USER:$MAMBA_USER env_f.yaml /tmp/env_f.yaml

RUN micromamba create -y -f /tmp/env.yaml && \
    micromamba create -y -f /tmp/env_a.yaml && \
    micromamba create -y -f /tmp/env_b.yaml && \
    micromamba create -y -f /tmp/env_f.yaml && \
    micromamba clean --all --yes

FROM mambaorg/micromamba:2.0.2
COPY --from=JAFFA /JAFFA /JAFFA
COPY --from=Fusim /opt/ /bin/
COPY --from=envbuilder /opt/conda/envs/ /opt/conda/envs/

ENV DEBIAN_FRONTEND=noninteractive

USER root
RUN apt update && \
    apt install -y libcurl4-openssl-dev libssl-dev libxml2-dev liblzma-dev r-base curl sed wget && \
    apt clean;

RUN R -q -e "install.packages(c('curl'))" && \
    Rscript -e "install.packages('BiocManager', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    Rscript -e "BiocManager::install(c('GenomicFeatures', 'Biostrings', 'biomaRt', 'rtracklayer', 'stringr', 'ggplot2', 'patchwork', 'cowplot'))"

ENV PATH="/opt/conda/envs/arriba:/opt/conda/envs/fusionseeker:/opt/conda/envs/starfusion:/opt/conda/envs/normal:/bin:/JAFFA/tools/bin:/JAFFA:/bin/fusim-0.2.2:/bin/Fusionseeker:$PATH"

COPY ./src /src
COPY ./models /model

ENTRYPOINT ["bash", "/src/sequential_run.sh"]
