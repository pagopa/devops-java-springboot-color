#
# Build
#
FROM maven:3.8.4-jdk-11-slim@sha256:04f8e5ba4a6a74fb7f97940bc75ac7340520728d2fb051ecc5c9ecbb9ba28b48 as buildtime

WORKDIR /build
COPY . .

RUN mvn clean package

#
# Docker RUNTIME
#
FROM adoptopenjdk/openjdk11:alpine-jre@sha256:14c221828cb2fe042de52ccf46d3a8e77f6c8d9cae75d22c8d84e768409e9faf as runtime

VOLUME /tmp
WORKDIR /app

COPY --from=buildtime /build/target/*.jar /app/app.jar
# The agent is enabled at runtime via JAVA_TOOL_OPTIONS.
ADD https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.2.7/applicationinsights-agent-3.2.7.jar /app/applicationinsights-agent.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]
