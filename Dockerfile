FROM python:3.8-alpine
LABEL maintainer="matteo.marchelli@gmail.chmod"

ARG TF_VER=0.12.19
ARG TF_URL=https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip
ARG TF_PATH=/usr/bin/terraform

ARG TF_CREDSTASH_VER=0.4.0
ARG TF_CREDSTASH_URL=https://github.com/sspinc/terraform-provider-credstash/releases/download/${TF_CREDSTASH_VERSION}/terraform-provider-credstash_linux_amd64
ARG TF_CREDSTASH_PATH=/usr/bin/terraform-provider-credstash

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

COPY add_aliases /usr/bin

RUN pip install awscli && \
    pip install google-cloud-storage

RUN apk add --no-cache jq curl bash groff && \
    curl -sL ${TF_URL} | unzip -p - > ${TF_PATH} && chmod +x ${TF_PATH} &&\
    curl -sL ${TF_CREDSTASH_URL} > ${TF_CREDSTASH_PATH} && chmod +x ${TF_CREDSTASH_PATH}


USER nobody
