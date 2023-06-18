#!/bin/bash

if [[ -z "${DEVICE_IP}" ]]; then
  echo "DEVICE_IP not set, exiting!" 1>&2
  exit 1
fi

if [[ -z "${DEVICE_PORT}" ]]; then
  echo "Using default 5555 port!" 1>&2
  port="5555"
else
  echo "Using port ${DEVICE_PORT}!"
  port=${DEVICE_PORT}
fi

adb connect ${DEVICE_IP}:${port}