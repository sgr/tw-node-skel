FROM armhf/node:6.10-slim

ARG DEBIAN_MIRROR_URL=http://ftp.jp.debian.org/debian
ARG AGENT_SRC_ZIP=tls.zip
ARG AGENT_SRC_URL=https://github.com/sgr/thingworx-nodejs-agent/archive/${AGENT_SRC_ZIP}
ENV HOME=/home/app

COPY ./api/twApi.so ${HOME}/bin/
COPY src/ ${HOME}/
WORKDIR ${HOME}

RUN set -x \
 && mkdir -p /opt/thingworx \
 && update-ca-certificates \
 && sed -i.bak -e "s%http://deb.debian.org/debian%${DEBIAN_MIRROR_URL}%g" /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y unzip node-gyp \
 && curl -OL ${AGENT_SRC_URL} \
 && mkdir tmp \
 && unzip -d tmp ${AGENT_SRC_ZIP} \
 && npm install \
 && npm install -g flatten-packages \
 && flatten-packages \
 && npm cache clean \
 && apt-get purge -y --auto-remove node-gyp \
 && rm -fr .node-gyp \
 && rm -fr tmp \
 && rm -f ${AGENT_SRC_ZIP}

