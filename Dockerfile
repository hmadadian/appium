
FROM maven:3-amazoncorretto-17-debian-bullseye

WORKDIR /root

#===============
# Build Arguments
#===============
ARG BUILD_TOOLS="29.0.3"
ENV CONFIG_FILE=/opt/selenium/config.toml
ENV SE_BIND_HOST false

#===============
# Install Packages
#===============
RUN apt-get update -y \
    && apt-get -y install --no-install-recommends \
    wget \
    unzip \
    curl \
    jq \
    xz-utils \
    supervisor \
    && apt-get -qyy autoremove \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && apt-get -qyy clean

#================================================
# Installing Android SDK
#================================================
RUN mkdir -p /opt/android/sdk \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip \
    && unzip commandlinetools-linux-9477386_latest.zip -d /opt/android/sdk \
    && rm commandlinetools-linux-9477386_latest.zip \
    && wget -q https://dl.google.com/android/repository/platform-tools-latest-linux.zip \
    && unzip platform-tools-latest-linux.zip -d /opt/android/ \
    && rm platform-tools-latest-linux.zip \
    && yes | /opt/android/sdk/cmdline-tools/bin/sdkmanager --sdk_root=/opt/android/ --licenses \
    && /opt/android/sdk/cmdline-tools/bin/sdkmanager --sdk_root=/opt/android/ --update

#================================================
# Initiating Android Build-tools
#================================================
RUN wget -q https://dl.google.com/android/repository/build-tools_r${BUILD_TOOLS}-linux.zip -O /root/build-tools-linux.zip \
    && unzip /root/build-tools-linux.zip -d /opt/android/build-tools/ \
    && build_tools_dir=$(unzip -Z1 /root/build-tools-linux.zip | head -n1) \
    && mv /opt/android/build-tools/${build_tools_dir} /opt/android/build-tools/${BUILD_TOOLS} \
    && rm -rf /root/build-tools-linux.zip \
    && ln -s /opt/android/platform-tools/adb /usr/bin

ENV ANDROID_HOME=/opt/android

#================================================
# Installing Latest LTS nodejs and Appium
#================================================
RUN nodejs_lts_latest=$(curl -s https://nodejs.org/download/release/index.json | jq -r -c '.[] | select(.lts != false).version' | head -n 1) \
    && wget https://nodejs.org/dist/${nodejs_lts_latest}/node-${nodejs_lts_latest}-linux-x64.tar.xz -P /root/ \
    && tar -xvf $(echo "/root/node-${nodejs_lts_latest}-linux-x64.tar.xz") -C /opt/ \
    && rm -rf $(echo "/root/node-${nodejs_lts_latest}-linux-x64.tar.xz") \
    && ln -s $(echo "/opt/node-${nodejs_lts_latest}-linux-x64/bin/npm") /usr/bin/ \
    && ln -s $(echo "/opt/node-${nodejs_lts_latest}-linux-x64/bin/node") /usr/bin/ \
    && ln -s $(echo "/opt/node-${nodejs_lts_latest}-linux-x64/bin/npx") /usr/bin/ \
    && npm install -g appium --allow-root --unsafe-perm=true \
    && ln -s $(echo "/opt/node-${nodejs_lts_latest}-linux-x64/bin/appium") /usr/bin/

#================================================
# Installing Latest Selenium
#================================================
RUN mkdir -p /opt/selenium \
    && selenium_latest=$(curl -s https://api.github.com/repos/SeleniumHQ/selenium/releases/latest | jq -r -c '.assets[] | select(.name | contains (".jar")).browser_download_url') \
    && selenium_version=$(curl -s https://api.github.com/repos/SeleniumHQ/selenium/releases/latest | jq -r '.tag_name' | sed 's/^selenium-//' ) \
    && wget $selenium_latest -O /opt/selenium/selenium-server.jar \
    && wget https://repo1.maven.org/maven2/org/seleniumhq/selenium/selenium-http-jdk-client/${selenium_version}/selenium-http-jdk-client-${selenium_version}.jar -O /opt/selenium/selenium-http-jdk-client.jar

#================================================
# Logging
#================================================
ENV APPIUM_WEB_LOG=false

#================================================
# RUN
#================================================

ADD config/ /root/config/

COPY supervisord.conf /root/

RUN chmod +x /root/config/* && chmod +x /root/supervisord.conf

CMD /usr/bin/supervisord --configuration /root/supervisord.conf