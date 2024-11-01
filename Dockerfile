
#FROM python:3.12-slim-bookworm
#COPY --from=ghcr.io/astral-sh/uv:0.4.26 /uv /uvx /bin/

#COPY requirements.txt .
#RUN uv pip install -r requirements.txt

#FROM quay.io/biocontainers/pbmm2:1.16.0--h9ee0642_0 AS ONE_P2
#FROM quay.io/biocontainers/pbfusion:0.3.1--hdfd78af_0 AS PBFusion
#FROM quay.io/biocontainers/longgf:0.1.2--h4ac6f70_7 AS LongGF
#FROM davidsongroup/jaffa:2.4 AS JAFFA
#FROM quay.io/biocontainers/minimap2:2.28--he4a0461_2 AS Minimap2
#FROM quay.io/biocontainers/arriba:2.4.0--hdbdd923_4 AS Arriba
#FROM quay.io/biocontainers/star:2.7.11b--h43eeafb_2 AS Star
#FROM quay.io/biocontainers/genion:1.2.3--hdcf5f25_1 AS Genion
#FROM quay.io/biocontainers/star-fusion:1.10.0--hdfd78af_1 AS Starfusion
#FROM staphb/samtools:1.9 AS Samtools
#FROM r-base:4.4.0 AS Rbase

#FROM mambaorg/micromamba:2.0.2

#COPY --chown=$MAMBA_USER:$MAMBA_USER requirements.txt /tmp/requirements.txt
#RUN micromamba install -y -n base -f /tmp/requirements.txt && \
#    micromamba clean --all --yes

#COPY requirements.txt .
#RUN micromamba create -f requiremnts.txt


FROM ubuntu:22.04 AS Fusim
RUN apt-get update && \
    apt-get install -y wget unzip;

RUN mkdir /opt/ && \
    cd /opt/ && \
    wget https://github.com/aebruno/fusim/raw/master/releases/fusim-0.2.2-bin.zip;

FROM ubuntu:22.04
#COPY --from=ONE_P2 /usr/local/bin/pbmm2 /bin/
#COPY --from=PBFusion /usr/local/bin/pbfusion /bin/
#COPY --from=Genion /opt/conda/envs/env/bin//genion /bin/
#COPY --from=Minimap2 /usr/local/bin/minimap2 /bin/
#COPY --from=JAFFA /JAFFA /JAFFA
#COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
#COPY --from=Rbase /usr/bin /bin/
COPY --from=Fusim /opt/ /bin/

RUN apt-get update && \
    apt-get install -y openjdk-11-jre-headless wget unzip && \
    apt-get clean;

ENV PATH="$PATH:/bin:/JAFFA/tools/bin:/JAFFA:/fusim-0.2.2"

#FROM ghcr.io/astral-sh/uv:0.2.12 AS builder

#RUN wget -O fusim-0.2.2.zip https://github.com/aebruno/fusim/raw/master/releases/fusim-0.2.2-bin.zip \

#FROM ghcr.io/astral-sh/uv:0.2.12 AS 

# Use a multi-stage build to first get uv
#FROM ghcr.io/astral-sh/uv:0.2.12 AS uv
# Choose your python version here
#FROM python:3.10.1-slim-buster
# Create a virtual environment with uv inside the container
#RUN --mount=from=uv,source=/uv,target=./uv \
#    ./uv venv /opt/venv
# We need to set this environment variable so that uv knows where
# the virtual environment is to install packages
#ENV VIRTUAL_ENV=/opt/venv
# Make sure that the virtual environment is in the PATH so
# we can use the binaries of packages that we install such as pip
# without needing to activate the virtual environment explicitly
#ENV PATH="/opt/venv/bin:$PATH"



#RUN wget -O fusim-0.2.2.zip https://github.com/aebruno/fusim/raw/master/releases/fusim-0.2.2-bin.zip \
#  unzip fusim-0.2.2.zip

#COPY

#COPY requirements.txt .
#COPY sequential_run.sh .
#COPY envionment.config .
#COPY generate_annotation_files.sh .
#COPY generate_breakpoints.sh .
#COPY generate_fusim.sh .
#COPY create_fusim_ref.R .

# The /app directory should act as the main application directory
#WORKDIR /usr/src

#CMD ["conda", "run", "-n", "env-a", "/bin/bash”]

#FROM ubuntu:latest

