# ╔═════════════════════════════════════════════════════╗
# ║                       SETUP                         ║
# ╚═════════════════════════════════════════════════════╝
  # GLOBAL
  ARG APP_UID=1000 \
      APP_GID=1000 \
      PYTHON_VERSION=3.13

  # :: FOREIGN IMAGES
  FROM 11notes/util AS util

# ╔═════════════════════════════════════════════════════╗
# ║                       BUILD                         ║
# ╚═════════════════════════════════════════════════════╝
  # BUILD / PYTHON
  FROM alpine

# ╔═════════════════════════════════════════════════════╗
# ║                       IMAGE                         ║
# ╚═════════════════════════════════════════════════════╝
  # :: HEADER
  FROM 11notes/python:${PYTHON_VERSION}

  # :: default arguments
    ARG TARGETPLATFORM \
        TARGETOS \
        TARGETARCH \
        TARGETVARIANT \
        APP_IMAGE \
        APP_NAME \
        APP_VERSION \
        APP_ROOT \
        APP_UID \
        APP_GID \
        APP_NO_CACHE \
        PYTHON_VERSION

  # :: default python image
    ARG PIP_ROOT_USER_ACTION=ignore \
        PIP_BREAK_SYSTEM_PACKAGES=1 \
        PIP_DISABLE_PIP_VERSION_CHECK=1 \
        PIP_NO_CACHE_DIR=1 \
        UV_NO_CACHE=1 \
        UV_SYSTEM_PYTHON=true

  # :: default environment
    ENV APP_IMAGE=${APP_IMAGE} \
        APP_NAME=${APP_NAME} \
        APP_VERSION=${APP_VERSION} \
        APP_ROOT=${APP_ROOT}

  # :: app specific environment
    ENV LD_LIBRARY_PATH=/usr/lib

  # :: multi-stage
    COPY --from=util /usr/local/bin /usr/local/bin
    COPY --chown=${APP_UID}:${APP_GID} ./rootfs /

# :: RUN
  USER root
  RUN eleven printenv;

  # :: install dependencies
    RUN set -ex; \
      apk --no-cache --update --repository https://dl-cdn.alpinelinux.org/alpine/edge/community add \
        go2rtc; \
      apk --no-cache --update add \
        wget \
        bash \
        imlib2 \
        ffmpeg \
        iperf3 \
        git \
        grep \
        libgpiod \
        libpulse \
        libzbar \
        mariadb-connector-c \
        net-tools \
        nmap \
        openssh-client \
        pianobar \
        pulseaudio-alsa \
        socat \
        libturbojpeg \
        postgresql-libs;

    RUN set -ex; \
      pip3 install uv; \
      mkdir -p ${APP_ROOT}/etc; \
      curl -fsSL "https://github.com/home-assistant/core/archive/${APP_VERSION}.tar.gz" | tar xzf - -C /tmp --strip-components=1; \
      uv pip install --no-build --find-links https://wheels.home-assistant.io/musllinux/ \
        -r /tmp/requirements.txt \
        -r /tmp/requirements_all.txt \
        -r https://raw.githubusercontent.com/home-assistant/docker/refs/heads/master/requirements.txt \
        homeassistant=="${APP_VERSION}"; \      
      rm -rf /tmp/*; \
      chmod +x -R /usr/local/bin; \
      chown -R ${APP_UID}:${APP_GID} \
        ${APP_ROOT}; \
      apk --no-cache --update --virtual .build add \
        libcap; \
      setcap 'cap_net_bind_service=+ep' "/usr/local/bin/python${PYTHON_VERSION}"; \
      apk del --no-network .build;

    RUN set -ex; \
      # CVE-2025-43859
      pip3 install h11 --upgrade; \
      # CVE-2024-28397
      pip3 install js2py --upgrade;

# :: PERSISTENT DATA
  VOLUME ["${APP_ROOT}/etc"]

# :: HEALTH
  HEALTHCHECK --interval=5s --timeout=2s --start-interval=5s \
    CMD ["/usr/bin/curl", "-X", "GET", "-kILs", "--fail", "http://localhost:3000/"]

# :: EXECUTE
  USER ${APP_UID}:${APP_GID}
  ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]