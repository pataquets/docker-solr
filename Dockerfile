FROM pataquets/default-jre-headless:xenial

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install curl \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV SOLR_VERSION 4.10.4
ENV SOLR solr-${SOLR_VERSION}

#TODO: symlink instead of 'mv' as on makuk66/docker-solr
RUN \
  curl --fail --location --silent --show-error --output ${SOLR}.tgz \
    https://archive.apache.org/dist/lucene/solr/${SOLR_VERSION}/${SOLR}.tgz \
  && \
  tar xvf ${SOLR}.tgz && \
  rm -v ${SOLR}.tgz && \
  mv ${SOLR} /opt/solr

WORKDIR /opt/solr/example

ENTRYPOINT [ "java", "-jar", "start.jar" ]
