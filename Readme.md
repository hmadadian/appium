Our case usage:

	$ docker run -d -p 5555:5555 -e DEVICE_IP=192.168.10.20 -v /root/config2.toml:/opt/selenium/config.toml:ro --name appium --platform=linux/amd64 vpsco/appium:1.3

for others (runing locally with seleniumhub):

	$ docker run -d -p 5555:5555 -e SE_EVENT_BUS_HOST=selenium-hub -e SE_EVENT_BUS_PUBLISH_PORT=4442 -e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 -v /Users/hamed.madadian/Desktop/config.toml:/opt/selenium/config.toml:ro --name selenium-node --platform=linux/amd64 --net selenium-network --add-host host.docker.internal:host-gateway selenium/node-base:latest