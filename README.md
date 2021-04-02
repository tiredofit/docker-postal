# hub.docker.com/r/tiredofit/postal

[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/postal.svg)](https://hub.docker.com/r/tiredofit/postal)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/postal.svg)](https://hub.docker.com/r/tiredofit/postal)
[![Docker Layers](https://images.microbadger.com/badges/image/tiredofit/postal.svg)]

## Introduction

Dockerfile to build a [Postal](https://github.com/atech/postal) SMTP server for sending and receiving SMTP / HTTP API email.
* This Container uses a [customized Alpine base](https://hub.docker.com/r/tiredofit/alpine) which includes [s6
overlay](https://github.com/just-containers/s6-overlay) enabled for PID 1 Init capabilities, [zabbix-agent](https://zabbix.org) for
individual container monitoring, Cron also installed along with other tools (bash,curl, less, logrotate, nano, vim) for easier
management.

* Contains Fail2Ban for blocking repeat authentication offenders


[Changelog](CHANGELOG.md)

## Authors

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [Introduction](#introduction)
- [Authors](#authors)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Quick Start](#quick-start)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
    - [Application Settings](#application-settings)
    - [DNS Settings](#dns-settings)
    - [Security Settings](#security-settings)
    - [Performance Settings](#performance-settings)
    - [Logging Settings](#logging-settings)
    - [Database Settings](#database-settings)
    - [Anti Spam Settings](#anti-spam-settings)
    - [Anti Virus Settings](#anti-virus-settings)
    - [SMTP Settings](#smtp-settings)
      - [Client](#client)
      - [Server](#server)
      - [Management System](#management-system)
      - [Relay](#relay)
    - [Other Settings](#other-settings)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [References](#references)

## Prerequisites

[RabbitMQ Server](https://github.com/tiredofit/docker-rabbitmq)
[MariaDB Server](https://github.com/tiredofit/docker-mariadb)
[Spamassassin](https://github.com/tiredofit/docker-spamassassin) *optional*
[Clam Antivirus](https://github.com/tiredofit/docker-clamav) *optional*

## Installation

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/postal) and is the recommended method of
installation.


```bash
docker pull hub.docker.com/tiredofit/postal:(imagetag)
```

The following image tags are available:
* `latest` - Most recent release of Postal

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working
[docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.


## Configuration
### Environment Variables

Along with the Environment Variables from the [Base image](https://hub.docker.com/r/tiredofit/alpine), below is the complete list of
available options that can be used to customize your installation.

#### Application Settings
| Parameter                 | Description                              | Default |
| ------------------------- | ---------------------------------------- | ------- |
| `ENABLE_TRACKING`         | Enable Click Tracking `true` or `false`  | `true`  |
| `MAX_DELIVERY_ATTEMPTS`   | Maximum Delivery Attempts before failing | `18`    |
| `MAX_HOLD_EXPIRY_DAYS`    | Maximum Holding days before expiring     | `7`     |
| `SUPPRESSION_LIST_EXPIRY` | Suppression List expiry in days          | `30`    |

#### DNS Settings
| Parameter                  | Description                                         | Default                |
| -------------------------- | --------------------------------------------------- | ---------------------- |
| `DNS_HOSTNAME`             | Domain Name Mail Server                             | `example.com`          |
| `DNS_MX`                   | MX Record Hostnames - Seperate multiple with commas |                        |
| `DNS_SPF`                  | SPF Hostname                                        | `spf.$DNS_HOSTNAME`    |
| `DNS_RETURN_PATH`          | Return path Hostname                                | `rp.$DNS_HOSTNAME`     |
| `DNS_ROUTE_DOMAIN`         | `Routing Domain`                                    | `routes.$DNS_HOSTNAME` |
| `DNS_TRACK_DOMAIN`         | `Tracking Domain`                                   | `track.$DNS_HOSTNAME`  |
| `DNS_DKIM_IDENTIFIER`      | DKIM Identifier                                     | `postal`               |
| `DNS_DOMAIN_VERIFY_PREFIX` | Domain verification prefix                          | `postal-verification`  |
| `DNS_RETURN_PATH_PREFIX`   | Custom Return Path Prefix                           | `psrp`                 |

#### Security Settings
| Parameter            | Description                                             | Default |
| -------------------- | ------------------------------------------------------- | ------- |
| `ENABLE_FAIL2BAN`    | Block hsots that repeatedly fail authentication         | `TRUE`  |
| `FAIL2BAN_LOG_FILE`  | Log Location for Fail2ban `/logs/fail2ban/fail2ban.log` |
| `FAIL2BAN_TIME_FIND` | Track failures for this time period                     | `10m`   |
| `FAIL2BAN_TIME_BAN`  | Time to ban repeat offenders                            | `10m`   |
| `FAIL2BAN_MAX_RETRY` | Ban after how many tries during time period             | `5`     |


#### Performance Settings
| Parameter         | Description                  | Default |
| ----------------- | ---------------------------- | ------- |
| `WORKERS_AMOUNT`  | Amount of Workers            | `1`     |
| `WORKERS_THREADS` | Amount of Threads per worker | `4`     |


#### Logging Settings
| Parameter          | Description                                              | Default  |
| ------------------ | -------------------------------------------------------- | -------- |
| `LOG_AUTH_FAILURE` | Log Authentication Failures (Used for Fail2ban blocking) | `TRUE`   |
| `LOG_CONSOLE`      | Log to Stdout Console `true` or `false`                  | `true`   |
| `LOG_LOCATION`     | Log Location                                             | `/logs/` |
| `LOG_SIZE_MAX`     | Maximum Log Size in KB                                   | `9999`   |

#### Database Settings
| Parameter        | Description                                                                            | Default |
| ---------------- | -------------------------------------------------------------------------------------- | ------- |
| `DB_HOST`        | Hostname of MariaDB Container e.g. `postal-db`                                         |         |
| `DB_NAME`        | Name of MariaDB Database e.g. `postal`                                                 |         |
| `DB_USER`        | Database Username e.g. `postal`                                                        |         |
| `DB_PASS`        | Password for Above User e.g. `password`                                                |         |
| `DB_PORT`        | MariaDB Server Port                                                                    | `3306`  |
| `DB_ROOT_PASS`   | Needed for first boot - Assigns privileges to $DB_USER. This is your MariaDB Root Pass |         |
| `RABBITMQ_HOST`  | RabbitMQ Hostname or Container                                                         |         |
| `RABBITMQ_VHOST` | RabbitMQ VHost shard                                                                   |         |
| `RABBITMQ_USER`  | RabbitMQ Username                                                                      |         |
| `RABBITMQ_PASS`  | RabbitMQ Password                                                                      |         |
| `RABBITMQ_PORT`  | RabbitMQ Port                                                                          | `5672`  |

#### Anti Spam Settings
| Parameter             | Description                           | Default |
| --------------------- | ------------------------------------- | ------- |
| `ENABLE_SPAMASSASSIN` | Enable Spamassassin `true` or `false` | `false` |
| `SPAMASSASSIN_HOST`   | Hostname of Spamassassin daemon       |         |
| `SPAMASSASSIN_PORT`   | TCP Port of spamassassin daemon       | `737`   |

#### Anti Virus Settings
| Parameter       | Description                     | Default |
| --------------- | ------------------------------- | ------- |
| `ENABLE_CLAMAV` | Enable ClamAV `true` or `false` | `false` |
| `CLAMAV_HOST`   | Hostname of Clamd Server        |         |
| `CLAMAV_PORT`   | TCP Port of Clamd Server        | `3310`  |

#### SMTP Settings
##### Client
| `SMTP_CLIENT_OPEN_TIMEOUT` | Timeout for an Open Connection in seconds | `30` |
| `SMTP_CLIENT_READ_TIMEOUT` | Timeout for Reading Data in seconds | `60` |

##### Server
| Parameter                            | Description                                        | Default           |
| ------------------------------------ | -------------------------------------------------- | ----------------- |
| `SMTP_SERVER_ENABLE_TLS`             | Enable TLS                                         | `false`           |
| `SMTP_SERVER_HELO_HOSTNAME`          | What Hostname to send for HELO                     | `$DNS_HOSTNAME`   |
| `SMTP_SERVER_LOG_CONNECTIONS`        | Log SMTP Connections                               | `true`            |
| `SMTP_SERVER_MAX_MESSAGE_SIZE`       | Max message size in Megabytes                      | `50`              |
| `SMTP_SERVER_PORT`                   | Listening Port for Postal Main SMTP Server         | `25`              |
| `SMTP_SERVER_PROXY_PROTOCOL`         | Utilize Proxy Protocol                             | `false`           |
| `SMTP_SERVER_SSL_VERSION`            | SSL Versions                                       | `SSLv23`          |
| `SMTP_SERVER_STRIP_RECEIVED_HEADERS` | Strip Recieved Headers                             | `false`           |
| `SMTP_SERVER_TLS_CERT`               | TLS Cert Location (Will authgenerate if not exist) | `/certs/cert.pem` |
| `SMTP_SERVER_TLS_CIPHERS`            | TLS Ciphers to use                                 |                   |
| `SMTP_SERVER_TLS_KEY`                | TLS Key Location (Will autogenerate if not exist)  | `/certs/key.pem`  |

##### Management System
| Parameter           | Description                                                                    | Default                 |
| ------------------- | ------------------------------------------------------------------------------ | ----------------------- |
| `SMTP_FROM_ADDRESS` | From Address for Postam Management System                                      | `postal@yourdomain.com` |
| `SMTP_FROM_NAME`    | From Name for Postal Management System                                         | `Postal`                |
| `SMTP_HOST`         | SMTP Server to be used to send messages from Postal Management System to users | `127.0.0.1`             |
| `SMTP_PORT`         | SMTP Port to be used to send messages from Postal Management System to Users   | `25`                    |
| `SMTP_USER`         | Username to authenticate to SMTP Server                                        |                         |
| `SMTP_PASS`         | Password to authenticate to SMTP Server                                        |                         |
##### Relay
| Parameter             | Description                                  | Default |
| --------------------- | -------------------------------------------- | ------- |
| `SMTP_RELAY_HOST`     | Relay all outbound messages to this hostname |         |
| `SMTP_RELAY_PORT`     | SMTP Relay Port                              | `25`    |
| `SMTP_RELAY_SSL_MODE` | Relay SSL / TLS Mode                         | `Auto`  |

#### Other Settings
| Parameter                   | Description                                                                  | Default                  |
| --------------------------- | ---------------------------------------------------------------------------- | ------------------------ |
| `CONFIG_LOCATION`           | Configuration File                                                           | `/app/config/postal.yml` |
| `SETUP_TYPE`                | Choose `AUTO` or `MANUAL` Setup type - Auto uses these environment variables | `AUTO`                   |
| `FAST_SERVER_BIND_IP`       | Bind IP for the Web Interface                                                | `0.0.0.0`                |
| `FAST_SERVER_BIND_PORT_TLS` | Bind Port for the TLS Tracking Service                                       | `8443`                   |
| `FAST_SERVER_BIND_PORT`     | Bind Port for the Tracking Server                                            | `8080`                   |
| `WEB_BIND_IP`               | Bind IP for the Web Interface                                                | `0.0.0.0`                |
| `WEB_BIND_PORT`             | Bind Port for the Web Interface                                              | `5000`                   |
| `WEB_HOSTNAME`              | Hostname for Web Interface                                                   | `postal.example.com`     |
| `WEB_MAX_THREADS`           | Max Threads for Web Interface                                                | `5`                      |
| `WEB_PROTOCOL`              | Protocol for Web Interface `http` or `https`                                 | `http`                   |

### Networking

| Port   | Description            |
| ------ | ---------------------- |
| `25`   | SMTP                   |
| `80`   | Web Interface          |
| `8080` | Fast Server /Tracking  |
| `8443` | Fast Server / Tracking |
| `5000` | Puma`                  |

## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. postal) bash
```

## References

* https://github.com/atech/postal

