# Build stage
FROM public.ecr.aws/docker/library/maven:3.9-amazoncorretto-21@sha256:378d7b2d07742a557989e3494e5d6bf31ed599ff9f0a0b2f490ceaac48c91370 AS builder

WORKDIR /build
COPY . .
RUN --mount=type=cache,target=/root/.m2 mvn clean package -DskipTests

# Runtime stage
FROM public.ecr.aws/docker/library/eclipse-temurin:21-alpine-3.20@sha256:108c96f846c4f8affd722908f8392eb15d123b21395616dfbf8b2e6f48db44fa

WORKDIR /app

# Add dependencies for security and monitoring
RUN apk add --no-cache \
    curl \
    tzdata \
    && addgroup -S javauser \
    && adduser -S javauser -G javauser \
    # Set system timezone
    && cp /usr/share/zoneinfo/Europe/Rome /etc/localtime \
    && echo "Europe/Rome" > /etc/timezone

# Create log directory and set permissions
RUN mkdir -p /app/logs && \
    chown -R javauser:javauser /app/logs

# Copy application bundle
COPY --from=builder /build/target/*.jar app.jar

# Add Application Insights agent
ADD --chmod=644 https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.4.17/applicationinsights-agent-3.4.17.jar applicationinsights-agent.jar

# Configure permissions
RUN chown -R javauser:javauser /app
USER javauser

# Application Insights configuration
ENV APPLICATIONINSIGHTS_CONNECTION_STRING=""
ENV APPLICATIONINSIGHTS_ROLE_NAME="devops-java-springboot-color"

# Add volume for logs
VOLUME /app/logs

# Configure container
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-javaagent:/app/applicationinsights-agent.jar", "-jar", "/app/app.jar"]
