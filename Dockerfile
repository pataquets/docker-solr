FROM pataquets/default-jre-headless

RUN \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive \
		apt-get -y install wget \
	&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ENV SOLR_VERSION 4.10.2
ENV SOLR solr-$SOLR_VERSION

#TODO: symlink instead of 'mv' as on makuk66/docker-solr
RUN \
 wget https://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
 tar xvf $SOLR.tgz && \
 rm -v $SOLR.tgz && \
 mv $SOLR /opt/solr

##############################################################################
###	Install Apache Tika
##############################################################################
ENV TIKA_VERSION 1.7
ENV TIKA_JAR_NAME tika-app-${TIKA_VERSION}.jar
ENV TIKA_DOWNLOAD_URL https://archive.apache.org/dist/tika/${TIKA_JAR_NAME}

RUN \
  mkdir -vp /opt/tika && \
  wget ${TIKA_DOWNLOAD_URL} -O /opt/tika/${TIKA_JAR_NAME} && \
  chmod -v a+x /opt/tika/${TIKA_JAR_NAME} && \
  ln -vs /opt/tika/${TIKA_JAR_NAME} /usr/local/bin/tika.jar \
##############################################################################

WORKDIR /opt/solr/example

ENTRYPOINT [ "java", "-jar", "start.jar" ]
