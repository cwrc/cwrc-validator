# CWRC Validation service 
# build environment

# First draft; rough prototype


######## Stage #1: build

FROM maven:3-jdk-13 AS build_stage

ARG APP_SRC=/app

# copy git repo into the image build
COPY . ${APP_SRC} 

# Run Maven to build Tomcat WAR file
WORKDIR ${APP_SRC}
RUN mvn dependency:go-offline
RUN mvn compile && mvn package war:war


######## stage #2 Tomcat

FROM tomcat:9 AS tomcat_stage

ARG APP_SRC=/app

# Copy web application
RUN rm -rf  ${CATALINA_HOME}/webapps/*
COPY --from=build_stage "${APP_SRC}/target/*.war" "${CATALINA_HOME}/webapps/ROOT.war"
