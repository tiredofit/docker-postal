FROM tiredofit/ruby:2.6-alpine
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

ENV ENABLE_CRON=FALSE \
    ENABLE_SMTP=FALSE

RUN set -x && \
# Create User
    addgroup -g 2525 postal && \
    adduser -S -D -G postal -u 2525 -h /opt/postal/ postal && \
    \
# Build Dependencies
    apk update && \
    apk add --no-cache --virtual .postal-build-deps \
            build-base \
            git \
            mariadb-dev \
            && \
	    \
    apk add --no-cache --virtual .postal-run-deps \
            expect \
            nodejs \
            mariadb-client \
            mariadb-connector-c \
            sudo \
            && \
            \
### Fetch Source and install Ruby Dependencies
    gem install bundler && \
    gem install procodile && \
    git clone https://github.com/atech/postal /opt/postal && \
    \
### Install Ruby Gems and dependencies
    /opt/postal/bin/postal bundle /opt/postal/vendor/bundle && \
    \
### Housekeeping
    ln -s /usr/local/bundle/bin/procodile /usr/sbin && \
    mkdir -p /opt/postal/certs && \
    \
# Cleanup
    chown -R postal. /opt/postal && \
    rm -rf && \
    apk del .postal-build-deps && \
    rm -rf /tmp/* /var/cache/apk/* 

### Networking Setup
EXPOSE 80 5000

### Add Files and Assets
ADD install /
