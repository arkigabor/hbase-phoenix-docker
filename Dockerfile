FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends tini wget openjdk-8-jre-headless python2  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*

ENV HBASE_VERSION=2.4.18
ENV PHOENIX_HBASE_VERSION=2.4
ENV PHOENIX_VERSION=5.1.3

RUN ln -sf /usr/bin/python2.7 /usr/local/bin/python

RUN wget https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz  && \
    tar -xzf hbase-${HBASE_VERSION}-bin.tar.gz -C /opt  && \
    rm hbase-${HBASE_VERSION}-bin.tar.gz  && \
    ln -s /opt/hbase-${HBASE_VERSION} /opt/hbase
ENV HBASE_HOME=/opt/hbase
ENV PATH=${HBASE_HOME}/bin:${PATH}

RUN wget https://downloads.apache.org/phoenix/phoenix-${PHOENIX_VERSION}/phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin.tar.gz  && \
    tar -xzf phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin.tar.gz -C /opt  && \
    rm phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin.tar.gz  && \
    mv /opt/phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin/phoenix-server-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}.jar /opt/hbase/lib  && \
    mkdir -p /opt/phoenix  && \
    mv /opt/phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin/bin /opt/phoenix  && \
    mv /opt/phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin/lib /opt/phoenix  && \
    mv /opt/phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin/phoenix-client-embedded-hbase-2.4-5.1.3.jar /opt/phoenix  && \
    rm -rf /opt/phoenix-hbase-${PHOENIX_HBASE_VERSION}-${PHOENIX_VERSION}-bin
ENV PATH=/opt/phoenix/bin:${PATH}

RUN mkdir -p /data/hbase /data/zookeeper
COPY hbase-site.xml ${HBASE_HOME}/conf/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 2181 8080 9090 16000 16010 16020 16030

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
