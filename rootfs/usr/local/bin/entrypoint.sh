#!/bin/ash
  if [ -z "${1}" ]; then
    ln -sf /proc/self/fd/1 ${APP_ROOT}/etc/home-assistant.log
    set -- python \
      -m homeassistant \
      --config ${APP_ROOT}/etc
    eleven log start
  fi

  exec "$@"