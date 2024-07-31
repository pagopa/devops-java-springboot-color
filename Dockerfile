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
FROM adoptopenjdk/openjdk11:alpine-jre@sha256:f2939f2ff30b2800f9c65fd2370fbcc13c699e2c1fa0f86982343936220116f6 as runtime

VOLUME /tmp
WORKDIR /app

COPY --from=buildtime /build/target/*.jar /app/app.jar
# The agent is enabled at runtime via JAVA_TOOL_OPTIONS.
ADD https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.2.7/applicationinsights-agent-3.2.7.jar /app/applicationinsights-agent.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]
