## 3.0.3 2021-11-15 <dave at tiredofit dot ca>

   ### Added
      - Postal 2.1.0


## 3.0.2 2021-10-06 <dave at tiredofit dot ca>

   ### Changed
      - Add more logrotate scripts for some logfiles


## 3.0.1 2021-10-06 <dave at tiredofit dot ca>

   ### Changed
      - Change the Certificate permissions


## 3.0.0 2021-10-06 <dave at tiredofit dot ca>

   ### Added
      - Updated to support new Postal 2.x release
      - Alpine 3.14

   ### Changed
      - Changes to environment variables, mapped folders, and persistent configuration files. See README.md
      - Upgrading from existing install is possible without much effort, just madke sure to map /config and /logs


## 2.1.6 2020-09-27 <dave at tiredofit dot ca>

   ### Changed
      - Fix logrotate


## 2.1.5 2020-09-13 <dave at tiredofit dot ca>

   ### Changed
      - Delete original fail2ban configuration as it throws errors with SSH


## 2.1.4 2020-09-13 <dave at tiredofit dot ca>

   ### Changed
      - Fix Fail2ban


## 2.1.3 2020-09-13 <dave at tiredofit dot ca>

   ### Added
      - Force Postal to run in background
      - Introduce Fail2ban Support
      - Introduce Log Rotation


## 2.1.2 2020-06-16 <dave at tiredofit dot ca>

   ### Changed
      - Change default SpamAssassin Port to 783


## 2.1.1 2020-06-15 <dave at tiredofit dot ca>

   ### Added
      - Change Base image


## 2.1.0 2020-06-09 <dave at tiredofit dot ca>

   ### Added
      - Update to support tiredofit alpine 5.0.0 base image


## 2.0.1 2020-06-05 <dave at tiredofit dot ca>

   ### Changed
      - Move /etc/s6/services to /etc/services.d


## 2.0.0 2020-05-21 <dave at tiredofit dot ca>

   ### Added
      - Refactor Configuration Building
      - Allow Custom Configuration File
      - New Environment Variables - See README


## 1.3.0 2020-01-13 <dave at tiredofit dot ca>

   ### Added
      - Update to use Ruby 2.6


## 1.2.1 2020-01-02 <dave at tiredofit dot ca>

   ### Changed
      - Additional changes to support new tiredofit/alpine base image


## 1.2.0 2019-12-30 <dave at tiredofit dot ca>

   ### Added
      - Support new tiredofit/alpine base image


## 1.1.3 2018-10-23 <dave at tiredofit dot ca>

* Patchup

## 1.1.2 2018-10-23 <dave at tiredofit dot ca>

* SMTP_PASS environment variable fix

## 1.1.1 2018-10-23 <dave at tiredofit dot ca>

* Patchup for Alpine 3.8

## 1.1 2018-10-23 <dave at tiredofit dot ca>

* Added ability to change Web host directives including protocol
* Added SMTP User and Password Capabilities for sending user invites (Setup the server first before putting this in)

## 1.0 2018-07-14 <dave at tiredofit dot ca>

* Initial Release

