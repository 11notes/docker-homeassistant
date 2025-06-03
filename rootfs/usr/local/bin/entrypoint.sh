#!/bin/ash
  if [ -z "${1}" ]; then
    set -- \
      "python3" \
      -m homeassistant \
      --config ${APP_ROOT}/etc;   
       
    eleven log start
  fi

  exec "$@"