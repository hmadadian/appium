#!/bin/bash

if [ $APPIUM_WEB_LOG == true ]; then
  mkdir -p /root/noVNC/appium
  param="2>&1 | tee -a /root/log/appium.log"
else
  param=""
fi

appium="appium -p 4723 ${param}"
eval "${appium}"