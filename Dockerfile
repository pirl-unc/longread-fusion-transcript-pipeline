# Use a multi-stage build to first get uv
FROM ghcr.io/astral-sh/uv:0.2.12 AS uv
# Choose your python version here
FROM python:3.10.1-slim-buster
# Create a virtual environment with uv inside the container
RUN --mount=from=uv,source=/uv,target=./uv \
    ./uv venv /opt/venv
# We need to set this environment variable so that uv knows where
# the virtual environment is to install packages
ENV VIRTUAL_ENV=/opt/venv
# Make sure that the virtual environment is in the PATH so
# we can use the binaries of packages that we install such as pip
# without needing to activate the virtual environment explicitly
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

# The /app directory should act as the main application directory
WORKDIR /usr/src

