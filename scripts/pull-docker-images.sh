#!/bin/bash

# ==========================================
# 📋 LIST OF IMAGES TO PULL
# You can freely modify this array
# ==========================================
IMAGES=(
  "public.ecr.aws/docker/library/maven:3.9.3-amazoncorretto-17"
  # "public.ecr.aws/amazoncorretto/amazoncorretto:17.0.9-alpine" # alpine is not available
  "public.ecr.aws/docker/library/alpine:latest"
  "public.ecr.aws/docker/library/ubuntu:latest"
  "public.ecr.aws/docker/library/eclipse-temurin:17-jre"
  "public.ecr.aws/docker/library/node:18.13.0"
  "public.ecr.aws/docker/library/openjdk:17-jdk"
  "public.ecr.aws/docker/library/busybox:latest"
  "public.ecr.aws/docker/library/debian:stable-20240701-slim"
)

# ==========================================
# 🔽 START PULLING IMAGES
# ==========================================
echo "📦 Starting pull of ${#IMAGES[@]} images from Amazon ECR Public..."

for image in "${IMAGES[@]}"; do
  echo "➡️  Pulling: $image"
  if docker pull "$image"; then
    echo "✅ Successfully pulled: $image"
  else
    echo "❌ Error pulling: $image"
  fi
done

echo "🎉 Pull complete!"
