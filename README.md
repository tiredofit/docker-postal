# github.com/tiredofit/docker-postal

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-postal?style=flat-square)](https://github.com/tiredofit/docker-postal/releases/latest)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-postal/build?style=flat-square)](https://github.com/tiredofit/docker-postal/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/postal.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/postal/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/postal.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/postal/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

* * *

## About

Dockerfile to build a [Postal](https://github.com/postalserver/postal) SMTP server for sending and receiving SMTP / HTTP API email.

* Contains Fail2Ban for blocking repeat authentication offenders

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Prerequisites and Assumptions
- Required [RabbitMQ Server](https://github.com/tiredofit/docker-rabbitmq)
- Required [MariaDB Server](https://github.com/tiredofit/docker-mariadb)
- Optional [Spamassassin](https://github.com/tiredofit/docker-spamassassin)
- Optional [Clam Antivirus](https://github.com/tiredofit/docker-clamav)

## Installation

### Build from Source
Clone this repository and build the image with `docker build <arguments> (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/postal) and is the recommended method of installation.

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v6`, `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working
[docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory        | Description                                                                                          |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| `/config/`       | Auto generated Postal Config and Signing Key resides here                                            |
| `/logs/`         | Logfiles                                                                                             |
| `/assets/custom` | *Optional* Use this to drop files overop of the Postal sourcode for cherry picked overrides of files |
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |

#### Admin Accounts
| Parameter   | Description              | Default              |
| ----------- | ------------------------ | -------------------- |
| ADMIN_EMAIL | Email address of admin   | `postal@example.com` |
| ADMIN_FNAME | Name of Admin First Name | `Postal`             |
| ADMIN_LNAME | Name of Admin Last Name  | `Admin`              |
| ADMIN_PASS  | Password of Admin user   | `PostalMailServer`   |
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
| Parameter            | Description                                     | Default                       |
| -------------------- | ----------------------------------------------- | ----------------------------- |
| `ENABLE_FAIL2BAN`    | Block hsots that repeatedly fail authentication | `TRUE`                        |
| `FAIL2BAN_LOG_FILE`  | Log Location for Fail2ban                       | `/logs/fail2ban/fail2ban.log` |
| `FAIL2BAN_TIME_FIND` | Track failures for this time period             | `10m`                         |
| `FAIL2BAN_TIME_BAN`  | Time to ban repeat offenders                    | `10m`                         |
| `FAIL2BAN_MAX_RETRY` | Ban after how many tries during time period     | `5`                           |

#### Performance Settings
| Parameter         | Description                  | Default |
| ----------------- | ---------------------------- | ------- |
| `WORKERS_AMOUNT`  | Amount of Workers            | `1`     |
| `WORKERS_THREADS` | Amount of Threads per worker | `4`     |

#### Logging Settings
| Parameter      | Description                             | Default  |
| -------------- | --------------------------------------- | -------- |
| `LOG_CONSOLE`  | Log to Stdout Console `true` or `false` | `true`   |
| `LOG_PATH`     | Log Location                            | `/logs/` |
| `LOG_SIZE_MAX` | Maximum Log Size in KB                  | `9999`   |

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

| Parameter       | Description                              | Default |
| --------------- | ---------------------------------------- | ------- |
| `ENABLE_RSPAMD` | Enable RSpamD checking `true` or `false` | `false` |
| `RSPAMD_FLAGS`  | Flags to pass to rspamd daemon           | `null`  |
| `RSPAMD_HOST`   | Hostname of rspamd daemon                |         |
| `RSPAMD_PASS`   | RSpamd controller password               | `null`  |
| `RSPAMD_PORT`   | TCP Port of rspamd daemon                | `11334` |
| `RSPAMD_SSL`    | Use SSL for connecting to rspamd         | `FALSE` |

| Parameter                | Description                | Default |
| ------------------------ | -------------------------- | ------- |
| `SPAM_THRESHOLD`         | Amount to classify as Spam | `5.0`   |
| `SPAM_FAILURE_THRESHOLD` | Amount to fail as Spam     | `5.0`   |

#### Anti Virus Settings
| Parameter       | Description                     | Default |
| --------------- | ------------------------------- | ------- |
| `ENABLE_CLAMAV` | Enable ClamAV `true` or `false` | `false` |
| `CLAMAV_HOST`   | Hostname of Clamd Server        |         |
| `CLAMAV_PORT`   | TCP Port of Clamd Server        | `3310`  |

#### SMTP Settings
##### Client
| Parameter                  | Description                               | Default |
| -------------------------- | ----------------------------------------- | ------- |
| `SMTP_CLIENT_OPEN_TIMEOUT` | Timeout for an Open Connection in seconds | `30`    |
| `SMTP_CLIENT_READ_TIMEOUT` | Timeout for Reading Data in seconds       | `60`    |

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
| Parameter                   | Description                                                                  | Default              |
| --------------------------- | ---------------------------------------------------------------------------- | -------------------- |
| `CONFIG_FILE`               | Configuration File                                                           | `postal.yml`         |
| `CONFIG_PATH`               | Configuration Path                                                           | `/config/`           |
| `FAST_SERVER_BIND_IP`       | Bind IP for the Web Interface                                                | `0.0.0.0`            |
| `FAST_SERVER_BIND_PORT_TLS` | Bind Port for the TLS Tracking Service                                       | `8443`               |
| `FAST_SERVER_BIND_PORT`     | Bind Port for the Tracking Server                                            | `8080`               |
| `SETUP_TYPE`                | Choose `AUTO` or `MANUAL` Setup type - Auto uses these environment variables | `AUTO`               |
| `SIGNING_KEY_FILE`          | Signing Key File                                                             | `signing.key`        |
| `SIGNING_KEY_SIZE`          | Signing Key Size                                                             | `1024`               |
| `WEB_BIND_IP`               | Bind IP for the Web Interface                                                | `0.0.0.0`            |
| `WEB_BIND_PORT`             | Bind Port for the Web Interface                                              | `5000`               |
| `WEB_HOSTNAME`              | Hostname for Web Interface                                                   | `postal.example.com` |
| `WEB_MAX_THREADS`           | Max Threads for Web Interface                                                | `5`                  |
| `WEB_PROTOCOL`              | Protocol for Web Interface `http` or `https`                                 | `http`               |
### Networking

| Port   | Description            |
| ------ | ---------------------- |
| `25`   | SMTP                   |
| `80`   | Web Interface          |
| `8080` | Fast Server /Tracking  |
| `8443` | Fast Server / Tracking |
| `5000` | Puma`                  |

* * *
## Maintenance

### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

``bash
docker exec -it (whatever your container name is) bash
``
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* https://github.com/postalhq/postal

