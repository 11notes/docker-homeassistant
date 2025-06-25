![banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# HOMEASSISTANT
![size](https://img.shields.io/docker/image-size/11notes/homeassistant/2025.6.3?color=0eb305)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![version](https://img.shields.io/docker/v/11notes/homeassistant/2025.6.3?color=eb7a09)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![pulls](https://img.shields.io/docker/pulls/11notes/homeassistant?color=2b75d6)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)[<img src="https://img.shields.io/github/issues/11notes/docker-HOMEASSISTANT?color=7842f5">](https://github.com/11notes/docker-HOMEASSISTANT/issues)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![swiss_made](https://img.shields.io/badge/Swiss_Made-FFFFFF?labelColor=FF0000&logo=data:image/svg%2bxml;base64,PHN2ZyB2ZXJzaW9uPSIxIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgdmlld0JveD0iMCAwIDMyIDMyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxyZWN0IHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgZmlsbD0idHJhbnNwYXJlbnQiLz4KICA8cGF0aCBkPSJtMTMgNmg2djdoN3Y2aC03djdoLTZ2LTdoLTd2LTZoN3oiIGZpbGw9IiNmZmYiLz4KPC9zdmc+)

Run Home Assistant smaller, lightweight and more secure than ever

# SYNOPSIS 📖
**What can I do with this?** Run Home Assistant rootless and without s6.

# UNIQUE VALUE PROPOSITION 💶
**Why should I run this image and not the other image(s) that already exist?** Good question! All the other images on the market that do exactly the same don’t do or offer these options:

> [!IMPORTANT]
>* This image runs as 1000:1000 by default, most other images run everything as root
>* This image does not ship with any critical rated CVE and is automatically maintained via CI/CD, most other images mostly have no CVE scanning or code quality tools in place
>* This image is created via a secure, pinned CI/CD process and immune to upstream attacks, most other images have upstream dependencies that can be exploited
>* This image contains a patch to run rootless (Linux caps needed), most other images require higher caps
>* This image contains a proper health check that verifies the app is actually working, most other images have either no health check or only check if a port is open or ping works
>* This image works as read-only, most other images need to write files to the image filesystem

If you value security, simplicity and the ability to interact with the maintainer and developer of an image. Using my images is a great start in that direction.

# VOLUMES 📁
* **/homeassistant/etc** - Directory of all config and custom files

# COMPOSE ✂️
```yaml
name: "homeassistant"
services:
  db:
    image: "11notes/postgres:16"
    read_only: true
    environment:
      TZ: "Europe/Zurich"
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - "db.etc:/postgres/etc"
      - "db.var:/postgres/var"
      - "db.backup:/postgres/backup"
      - "db.cmd:/run/cmd"
    tmpfs:
      - "/run/postgresql:uid=1000,gid=1000"
      - "/postgres/log:uid=1000,gid=1000"
    networks:
      backend:
    restart: "always"

  cron:
    depends_on:
      db:
        condition: "service_healthy"
        restart: true
    image: "11notes/cron:4.6"
    environment:
      TZ: "Europe/Zurich"
      CRONTAB: |-
        0 3 * * * cmd-socket '{"bin":"backup"}' > /proc/1/fd/1
    volumes:
      - "db.cmd:/run/cmd"
    restart: "always"
  core:
    depends_on:
      db:
        condition: "service_healthy"
        restart: true
    image: "11notes/homeassistant:2025.6.3"
    read_only: true
    environment:
      TZ: "Europe/Zurich"
    volumes:
      - "etc:/homeassistant/etc"
    networks:
      frontend:
      backend:
    ports:
      - "3000:3000/tcp"
    restart: "always"

volumes:
  etc:
  db.etc:
  db.var:
  db.backup:
  db.cmd:

networks:
  frontend:
  backend:
    internal: true
```

# DEFAULT SETTINGS 🗃️
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user name |
| `uid` | 1000 | [user identifier](https://en.wikipedia.org/wiki/User_identifier) |
| `gid` | 1000 | [group identifier](https://en.wikipedia.org/wiki/Group_identifier) |
| `home` | /homeassistant | home directory of user docker |

# ENVIRONMENT 📝
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Will activate debug option for container image and app (if available) | |

# MAIN TAGS 🏷️
These are the main tags for the image. There is also a tag for each commit and its shorthand sha256 value.

* [2025.6.3](https://hub.docker.com/r/11notes/homeassistant/tags?name=2025.6.3)

### There is no latest tag, what am I supposed to do about updates?
It is of my opinion that the ```:latest``` tag is dangerous. Many times, I’ve introduced **breaking** changes to my images. This would have messed up everything for some people. If you don’t want to change the tag to the latest [semver](https://semver.org/), simply use the short versions of [semver](https://semver.org/). Instead of using ```:2025.6.3``` you can use ```:2025``` or ```:2025.6```. Since on each new version these tags are updated to the latest version of the software, using them is identical to using ```:latest``` but at least fixed to a major or minor version.

If you still insist on having the bleeding edge release of this app, simply use the ```:rolling``` tag, but be warned! You will get the latest version of the app instantly, regardless of breaking changes or security issues or what so ever. You do this at your own risk!

# REGISTRIES ☁️
```
docker pull 11notes/homeassistant:2025.6.3
docker pull ghcr.io/11notes/homeassistant:2025.6.3
docker pull quay.io/11notes/homeassistant:2025.6.3
```

# SOURCE 💾
* [11notes/homeassistant](https://github.com/11notes/docker-HOMEASSISTANT)

# PARENT IMAGE 🏛️
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

# BUILT WITH 🧰
* [homeassistant](https://github.com/home-assistant/core)
* [11notes/util](https://github.com/11notes/docker-util)

# GENERAL TIPS 📌
> [!TIP]
>* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS and to protect your endpoints
>* Use Let’s Encrypt DNS-01 challenge to obtain valid SSL certificates for your services

# CAUTION ⚠️
> [!CAUTION]
>* This image comes with a default configuration with some default settings and examples. Please provide your own configuration if used in production.

# SECURITY VULNERABILITIES REPORT ⚡
| ID | Severity | Risk | Vector | Source |
| --- | --- | --- | --- | --- |
| CVE-2023-49502 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-49502) |
| CVE-2025-1594 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2025-1594) |
| CVE-2023-50009 | high | low | [CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:L/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:L/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-50009) |
| CVE-2023-51795 | high | low | [CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:L/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:N/UI:N/S:U/C:L/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-51795) |
| CVE-2023-50008 | high | low | [CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-50008) |
| CVE-2023-50010 | high | low | [CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-50010) |
| CVE-2023-51791 | high | low | [CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-51791) |
| CVE-2023-51793 | high | low | [CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-51793) |
| CVE-2023-51794 | high | low | [CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-51794) |
| CVE-2023-51798 | high | low | [CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-51798) |
| CVE-2024-31582 | high | low | [CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:H/I:H/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2024-31582) |
| CVE-2023-52356 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2023-52356) |
| CVE-2024-31578 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2024-31578) |
| CVE-2025-22869 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2025-22869) |
| CVE-2025-22874 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:H/A:N) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2025-22874) |
| CVE-2025-29786 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2025-29786) |
| CVE-2025-49140 | high | low | [CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H](https://www.first.org/cvss/calculator/3.1#CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H) | [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2025-49140) |

# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-homeassistant/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-homeassistant/issues), thanks. If you have a question or inputs please create a new [discussion](https://github.com/11notes/docker-homeassistant/discussions) instead of an issue. You can find all my other repositories on [github](https://github.com/11notes?tab=repositories).

*created 25.06.2025, 07:22:20 (CET)*