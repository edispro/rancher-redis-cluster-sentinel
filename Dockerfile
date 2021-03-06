FROM redis:4.0.9

MAINTAINER Jérémie Bordier <jeremie.bordier@gmail.com>

ARG GIDDYUP_VERSION=0.19.0

RUN apt-get update \
  && apt-get install -y curl openssl ca-certificates wget jq \
  && update-ca-certificates \
  && mkdir -p /usr/local/etc/redis \
  && cd /usr/local/etc/redis \
  && wget http://download.redis.io/redis-stable/sentinel.conf \
  && chown redis:redis /usr/local/etc/redis/sentinel.conf \
  && wget https://github.com/rancher/giddyup/releases/download/v${GIDDYUP_VERSION}/giddyup -P /usr/local/bin \
  && chmod +x /usr/local/bin/giddyup

RUN rm -rf ~/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD update-master-externalservice.sh /
ADD docker-entrypoint.sh /
RUN chown root:root /docker-entrypoint.sh
RUN chmod 4755 /docker-entrypoint.sh
WORKDIR /data

EXPOSE 6379 16379 26379

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["redis-server", "/usr/local/etc/redis/sentinel.conf", "--sentinel"]
