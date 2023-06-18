#!/bin/bash

if [ ! -z "$SE_OPTS" ]; then
  echo "Appending Selenium options: ${SE_OPTS}"
fi

if [ "$GENERATE_CONFIG" = true ]; then
  echo "Generating Selenium Config"
  /opt/bin/generate_config
fi

EXTRA_LIBS="/opt/selenium/selenium-http-jdk-client.jar"

if [ ! -z "$SE_ENABLE_TRACING" ]; then
  EXTERNAL_JARS=$(</external_jars/.classpath.txt)
  EXTRA_LIBS=${EXTRA_LIBS}:${EXTERNAL_JARS}
  echo "Tracing is enabled"
  echo "Classpath will be enriched with these external jars : " ${EXTRA_LIBS}
else
  echo "Tracing is disabled"
fi

echo "Selenium Grid Node configuration: "
cat "$CONFIG_FILE"
echo "Starting Selenium Grid Node..."

java ${JAVA_OPTS:-$SE_JAVA_OPTS} -Dwebdriver.http.factory=jdk-http-client \
  -jar /opt/selenium/selenium-server.jar \
  --ext ${EXTRA_LIBS} node \
  --bind-host ${SE_BIND_HOST} \
  --config "$CONFIG_FILE" \
  ${SE_OPTS}