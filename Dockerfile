FROM pytorch/pytorch:2.3.0-cuda11.8-cudnn8-runtime

ENV DEBIAN_FRONTEND noninteractive

ARG TZ=America/New_York
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    g++ \
    git \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /pipeline

RUN pip install --upgrade pip
RUN pip install --no-cache-dir keyring keyrings.google-artifactregistry-auth # Authenticates to Artifact Registry

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && pip check

COPY *.py ./

# Set the entrypoint to Apache Beam SDK worker launcher.
COPY --from=apache/beam_python3.10_sdk:2.59.0 /opt/apache/beam /opt/apache/beam
ENTRYPOINT [ "/opt/apache/beam/boot" ]