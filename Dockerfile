FROM tiredofit/nginx:alpine-3.13
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV POSTAL_VERSION=master \
    POSTAL_REPO_URL=https://github.com/postalhq/postal \
    POSTAL_CONFIG_ROOT=/app/config \
    ENABLE_SMTP=FALSE \
    ZABBIX_HOSTNAME=postal-app

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
            nodejs \
            mariadb-client \
            mariadb-connector-c \
            openssl \
            ruby \
            && \
            \
### Fetch Source and install Ruby Dependencies
    gem install bundler -v 1.17.2 && \
    gem install procodile && \
    git clone https://github.com/postalhq/postal /app/ && \
    \
### Install Ruby Gems and dependencies
    /app/bin/postal bundle /app/vendor/bundle && \
    \
### Housekeeping
    ln -s /usr/local/bundle/bin/procodile /usr/sbin && \
    \
# Cleanup
    chown -R postal. /app/ && \
    apk del .postal-build-deps && \
    cd /etc/fail2ban && \
    rm -rf fail2ban.conf fail2ban.d jail.conf jail.d paths-*.conf && \
    rm -rf /tmp/* /var/cache/apk/*

### Networking Setup
EXPOSE 25 5000

### Add Files and Assets
ADD install /
