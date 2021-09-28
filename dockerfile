# base image
FROM ubuntu:16.04

# install openjdk-8-jdk
RUN apt-get update && \
	apt-get install -y openjdk-8-jdk

# copy required  files
#RUN mkdir app

#WORKDIR app
COPY target/spring-petclinic-2.5.0-SNAPSHOT.jar app.jar
CMD java -jar /app.jar

# EXPOSE 8080
EXPOSE 80
