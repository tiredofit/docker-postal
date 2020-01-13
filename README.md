# hub.docker.com/r/tiredofit/postal

[![Build Status](https://img.shields.io/docker/build/tiredofit/postal.svg)](https://hub.docker.com/r/tiredofit/postal)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/postal.svg)](https://hub.docker.com/r/tiredofit/postal)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/postal.svg)](https://hub.docker.com/r/tiredofit/postal)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/postal.svg)]

# Introduction

Dockerfile to build a [Postal](https://github.com/atech/postal) SMTP server for sending and receiving SMTP / HTTP API email.
* This Container uses a [customized Alpine base](https://hub.docker.com/r/tiredofit/debian) which includes [s6 
overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for 
individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier 
management. 



[Changelog](CHANGELOG.md)

# Authors

- [Dave Conroy](https://github.com/tiredofit/)

# Table of Contents

- [Introduction](#introduction)
    - [Changelog](CHANGELOG.md)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
    - [Data Volumes](#data-volumes)
    - [Environment Variables](#environmentvariables)   
- [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
   - [References](#references)

# Prerequisites

[RabbitMQ Server](https://github.com/tiredofit/docker-rabbitmq)
[MariaDB Server](https://github.com/tiredofit/docker-mariadb)
[Spamassassin](https://github.com/tiredofit/docker-spamassassin) *optional*
[Clam Antivirus](https://github.com/tiredofit/docker-clamav) *optional*

# Installation

Automated builds of the image are available on [Registry](https://hub.docker.com/r/tiredofit/postal) and is the recommended method of 
installation.


```bash
docker pull hub.docker.com/tiredofit/postal:(imagetag)
```

The following image tags are available:
* `latest` - Most recent release of postal w/Alpine Linux 3.11 + Ruby 2.6

# Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working 
[docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.


# Configuration

### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of 
available options that can be used to customize your installation.

| Parameter | Description |
|-----------|-------------|
| `DB_HOST`  | Hostname of MariaDB Container |
| `DB_NAME` | Name of MariaDB Database |
| `DB_USER` | Database Username |
| `DB_PASS` | Password for Above User |
| `DB_PORT` | MariaDB Server Port - Default `3306`
| `DB_ROOT_PASS` | Needed for first boot - Assigns privileges to $DB_USER. MySQL Root Pass |
| `RABBITMQ_HOST` | RabbitMQ Hostname or Container |
| `RABBITMQ_VHOST` | RabbitMQ VHost shard |
| `RABBITMQ_USER` | RabbitMQ Username |
| `RABBITMQ_PASS` | RabbitMQ Password |
| `RABBITMQ_PORT` | RabbitMQ Port - Default `5672` |
| `ENABLE_CLAMAV` | Enable ClamAV `true` or `false` - Default `false` |
| `ENABLE_SPAMASSASSIN` | Enable Spamassassin `true` or `false` - Default `false` |
| `CLAMAV_HOST` | Hostname of Clamd Server |
| `SPAMASSASSIN_HOST` | Hostname of Spamassassin Server |
| `CLAMAV_PORT` | TCP Port of Clamd Server - Default `3310` |
| `SPAMASSASSIN_PORT` | TCP Port of Spamassassin Process - Default `737` |
| `LOG_CONSOLE` | Log to Stdout Console `true` or `false` - Default `true` |
| `WEB_HOST` | Hostname of Webhost for SMTP Invites - Default `postal.example.com` |
| `WEB_PROTOCOL | Protocol of Webhost for SMTP Invites `http` or `https` - Default `http`


### Networking

| Port | Description        |
|-----------|---------------|
| `25`      | SMTP          |
| `587`     | Submission    |
| `5000`    | Procodile     |

# Maintenance

#### Shell Access

For debugging and maintenance purposes you may want access the containers shell. 

```bash
docker exec -it (whatever your container name is e.g. postal) bash
```

# References

* https://github.com/atech/postal

