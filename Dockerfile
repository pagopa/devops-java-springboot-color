#
# Build
#
FROM maven:3.8.4-jdk-11-slim as buildtime

WORKDIR /build
COPY . .

RUN mvn clean package

#
# Docker RUNTIME
#
FROM ghcr.io/pagopa/docker-base-springboot-openjdk11:v1.0.1@sha256:bbbe948e91efa0a3e66d8f308047ec255f64898e7f9250bdb63985efd3a95dbf

VOLUME /tmp
WORKDIR /app

RUN mkdir /app/logs
RUN chown spring:spring /app/logs

COPY --from=buildtime /build/target/*.jar /app/app.jar
# The agent is enabled at runtime via JAVA_TOOL_OPTIONS.
ADD https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.2.7/applicationinsights-agent-3.2.7.jar /app/applicationinsights-agent.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]
