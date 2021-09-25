# base image
FROM ubuntu:16.04

# install openjdk-8-jdk
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk

# copy required  files
RUN mkdir /app/
COPY app.jar /app/

WORKDIR /app

CMD java -jar /app/app.jar

EXPOSE 8080
