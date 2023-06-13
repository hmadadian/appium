	$ docker run -d -p 5555:5555 -e SE_EVENT_BUS_HOST=selenium-hub.finanzen.check24-int.de -e SE_EVENT_BUS_PUBLISH_PORT=32442 -e SE_EVENT_BUS_SUBSCRIBE_PORT=32443 -v /Users/hamed.madadian/Desktop/personal_ws/appium/config.toml:/opt/selenium/config.toml:ro --name selenium-node --platform=linux/amd64 vpsco/appium:1.2

for others (runing locally with seleniumhub):

	$ docker run -d -p 5555:5555 -e SE_EVENT_BUS_HOST=selenium-hub -e SE_EVENT_BUS_PUBLISH_PORT=4442 -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 -v /Users/hamed.madadian/Desktop/config.toml:/opt/selenium/config.toml:ro --name selenium-node --platform=linux/amd64 --net selenium-network --add-host host.docker.internal:host-gateway selenium/node-base:latest