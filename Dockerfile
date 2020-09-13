FROM tiredofit/ruby:2.6-alpine
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV POSTAL_CONFIG_ROOT=/app/config \
    ENABLE_SMTP=FALSE \
    ZABBIX_HOSTNAME=postal-app

RUN set -x && \
# Create User
    addgroup -g 2525 postal && \
    adduser -S -D -G postal -u 2525 -h /app/ postal && \
    \
# Build Dependencies
    apk update && \
    apk upgrade && \
    apk add -t .postal-build-deps \
            build-base \
            git \
            mariadb-dev \
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
            && \
            \
### Fetch Source and install Ruby Dependencies
    gem install bundler && \
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
