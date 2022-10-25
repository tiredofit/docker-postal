FROM docker.io/tiredofit/alpine:3.14
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV POSTAL_VERSION=2.1.0 \
    POSTAL_REPO_URL=https://github.com/postalhq/postal \
    POSTAL_CONFIG_ROOT=/app/config/ \
    CONTAINER_ENABLE_MESSAGING=FALSE \
    RAILS_ENV=production

RUN set -x && \
    addgroup -g 2525 postal && \
    adduser -S -D -G postal -u 2525 -h /app/ postal && \
    \
    apk update && \
    apk upgrade && \
    apk add -t .postal-build-deps \
            build-base \
            git \
            mariadb-dev \
            ruby-dev \
            && \
    \
    apk add -t .postal-run-deps \
            expect \
            fail2ban \
            gawk \
            mariadb-client \
            mariadb-connector-c \
            openssl \
            nodejs \
            ruby \
            ruby-bigdecimal \
            ruby-etc \
            ruby-io-console \
            && \
    \
    gem install bundler -v 1.17.2 && \
    \
### Fetch Source and install Ruby Dependencies
    git clone https://github.com/postalhq/postal /app/ && \
    cd /app && \
    bundle install -j "$(nproc)" && \
    if [ $POSTAL_VERSION = "main" ] || [ $POSTAL_VERSION = "master" ] ; then git -C /app rev-parse HEAD > /app/VERSION ; else echo $POSTAL_VERSION > /app/VERSION ; fi ; \
    \
# Cleanup
    chown -R postal. /app/ && \
    rm -rf /app/docker-compose.yml /app/Dockerfile /app/Makefile && \
    rm -rf /app/log & \
    rm -rf /root/.bundle /root/.gem && \
    cd /etc/fail2ban && \
    rm -rf fail2ban.conf fail2ban.d jail.conf jail.d paths-*.conf && \
    apk del .postal-build-deps && \
    rm -rf /tmp/* /var/cache/apk/*

### Networking Setup
EXPOSE 25 5000

### Add Files and Assets
ADD install /
