############################################################
# Dockerfile to build a Cerebro Elasticsearch plugin environment
############################################################

# Set the base image to openjdk:8-jre
FROM openjdk:8-jre

# File Author / Maintainer
MAINTAINER Marcio Godoi <souzagodoi@gmail.com>

# Run as a root user
USER root

ENV CEREBRO_HOME=/opt/cerebro

USER root

# Installing sudo module to support Logstash installation
RUN apt-get update && \
    apt-get -y install sudo vim curl

RUN wget https://github.com/lmenezes/cerebro/releases/download/v0.6.5/cerebro-0.6.5.tgz -P /tmp/cerebro && \
  tar -xvzf /tmp/cerebro/cerebro-0.6.5.tgz -C /tmp/cerebro && \
  rm -rf /tmp/cerebro/cerebro-0.6.5.tgz && \
  mv /tmp/cerebro/cerebro-0.6.5 /opt/cerebro && \
  rm -rf /tmp/cerebro

# Create elasticsearch group and user
RUN groupadd -g 1000 cerebro \
  && useradd -d "$CEREBRO_HOME" -u 1000 -g 1000 -s /sbin/nologin cerebro

ADD bin/entrypoint.sh /opt/cerebro/bin/docker-entrypoint.sh

RUN chmod 755 /opt/cerebro/bin/docker-entrypoint.sh

RUN chown -R cerebro:cerebro /opt/cerebro/

# Run the container as elasticsearch user
USER cerebro

WORKDIR "$CEREBRO_HOME"

ENTRYPOINT ["/opt/cerebro/bin/docker-entrypoint.sh"]

# Exposes http ports
EXPOSE 9000
