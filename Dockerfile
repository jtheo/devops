FROM python:3.8-alpine
LABEL maintainer="matteo.marchelli@gmail.com"

ARG TF_VER=0.12.19
ARG TF_URL=https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip
ARG TF_PATH=/usr/local/bin/terraform

ARG TF_CREDSTASH_VER=0.4.0
ARG TF_CREDSTASH_URL=https://github.com/sspinc/terraform-provider-credstash/releases/download/v${TF_CREDSTASH_VER}/terraform-provider-credstash_linux_amd64
ARG TF_CREDSTASH_PATH=/usr/local/bin/terraform-provider-credstash

ARG USER_NAME=cci
ARG USER_UGID=54321

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN pip install --upgrade awscli xmltodict PyJWT

RUN apk add --no-cache jq curl bash groff less ca-certificates git openssh-client sudo

RUN mkdir -p /usr/local/bin &&\
    curl -sL ${TF_URL} | unzip -p - > ${TF_PATH} && chmod +x ${TF_PATH} &&\
    curl -sL ${TF_CREDSTASH_URL} > ${TF_CREDSTASH_PATH} && chmod +x ${TF_CREDSTASH_PATH}

RUN addgroup -g ${USER_UGID} ${USER_NAME} && \
    adduser -h /${USER_NAME} -g 'circleci user' -s /bin/bash -G ${USER_NAME} -u ${USER_UGID} -D ${USER_NAME} &&\
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} && chmod 0440 /etc/sudoers.d/${USER_NAME} &&\
    echo 'export PS1="\[\e[36;1m\]\u\[\e[0;32m\]@\[\e[32;1m\]\h:\[\e[0;31m\] \w \[\e[0m\]: "' >> /${USER_NAME}/.bashrc &&\
    echo 'alias ll="ls -l"' >> /${USER_NAME}/.bashrc &&\
    chown -R ${USER_NAME}.${USER_NAME} /${USER_NAME}

USER ${USER_NAME}

WORKDIR /${USER_NAME}

