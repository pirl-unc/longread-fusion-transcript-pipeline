
#FROM python:3.12-slim-bookworm
#COPY --from=ghcr.io/astral-sh/uv:0.4.26 /uv /uvx /bin/

#COPY requirements.txt .
#RUN uv pip install -r requirements.txt

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

#FROM mambaorg/micromamba:2.0.2

#COPY --chown=$MAMBA_USER:$MAMBA_USER requirements.txt /tmp/requirements.txt
#RUN micromamba install -y -n base -f /tmp/requirements.txt && \
#    micromamba clean --all --yes

#COPY requirements.txt .
#RUN micromamba create -f requiremnts.txt

FROM ubuntu:22.04 AS Fusim

WORKDIR /opt

RUN apt-get update && \
    apt-get install -y wget unzip

RUN wget https://github.com/aebruno/fusim/raw/master/releases/fusim-0.2.2-bin.zip && \
    unzip fusim-0.2.2-bin.zip

RUN wget https://www.niehs.nih.gov/sites/default/files/2024-02/artbinmountrainier2016.06.05linux64.tgz && \
    tar xvzf artbinmountrainier2016.06.05linux64.tgz

#FROM rocker/r-ver:4.4.0 AS Rbase

#RUN R -q -e 'install.packages("curl")'
#RUN Rscript -e "install.packages('BiocManager', dependencies=TRUE, repos='http://cran.rstudio.com/')"
#    Rscript -e "BiocManager::install(c('GenomicFeatures', 'Biostrings', 'biomaRt', 'rtracklayer', 'stringr', 'ggplot2', 'patchwork', 'cowplot'))"
#    Rscript -e "BiocManager::install(c('GenomicFeatures', 'Biostrings', 'biomaRt', 'rtracklayer', 'stringr', 'ggplot2', 'patchwork', 'cowplot'),dependencies=TRUE')"

FROM mambaorg/micromamba:2.0.2 AS Micromamba
COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
COPY --chown=$MAMBA_USER:$MAMBA_USER env_a.yaml /tmp/env_a.yaml

RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

RUN micromamba create -y -f /tmp/env_a.yaml && \
    micromamba clean --all --yes

#FROM ubuntu:24.04
#COPY --from=Pbmm2 /usr/local/bin/pbmm2 /bin/
#COPY --from=PBFusion /usr/local/bin/pbfusion /bin/
#COPY --from=Genion /opt/conda/envs/env/bin//genion /bin/
#COPY --from=Minimap2 /usr/local/bin/minimap2 /bin/
COPY --from=JAFFA /JAFFA /JAFFA
#COPY --from=Rbase /usr/bin /bin/
COPY --from=Fusim /opt/ /bin/


ENV DEBIAN_FRONTEND=noninteractive

#RUN apt-get update && apt-get install -y wget bzip2 && \
#    wget -qO-  https://micromamba.snakepit.net/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
#RUN touch /root/.bashrc
#RUN ./bin/micromamba shell init -s bash -p /opt/conda
#RUN grep -v '[ -z "\$PS1" ] && return' /root/.bashrc  > /opt/conda/bashrc
#RUN apt-get clean autoremove --yes
#RUN rm -rf /var/lib/{apt,dpkg,cache,log}

USER root
#RUN apt-get update && \
#    apt-get install -y openjdk-11-jre-headless r-base curl && \
#    apt-get clean;

RUN Rscript -e "install.packages('BiocManager', dependencies=TRUE, repos='http://cran.rstudio.com/')" && \
    Rscript -e "BiocManager::install(c('GenomicFeatures', 'Biostrings', 'biomaRt', 'rtracklayer', 'stringr', 'ggplot2', 'patchwork', 'cowplot'))"

#COPY --from=Micromamba /usr/bin/ /bin/
#COPY --from=Rbase /usr/local/bin/ /bin/

#COPY --from=Rbase /usr/local/lib/R/etc/ldpaths /usr/local/lib/R/etc/ldpaths
#COPY --from=Rbase /usr/local/lib/R/bin/exec/R /usr/local/lib/R/bin/exec/R
#COPY --from=Rbase /usr/local/lib/R/site-library /usr/local/lib/R/site-library
#COPY --from=Rbase /usr/local/lib/R/library /usr/local/lib/R/library

#COPY --from=Micromamba /opt/conda/bin/ /bin/

ENV PATH="$PATH:/bin:/JAFFA/tools/bin:/JAFFA:/opt/fusim-0.2.2"



COPY ./src ./src

ENTRYPOINT ["bash", "./src/sequential_run.sh"]
