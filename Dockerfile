# syntax=docker/dockerfile:1

FROM golang:1.22-alpine AS build-stage
WORKDIR /app

# Copy embeded dirs
COPY public public/
COPY pages pages/
COPY i18n i18n/

# Setup and compile Go
COPY go.mod go.sum ./
RUN go mod download
COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /hibiscus

FROM alpine:3.20 AS deploy-stage
WORKDIR /

# Bring over the executable
COPY --from=build-stage /hibiscus /hibiscus

# Data dirs
VOLUME /data
VOLUME /config

EXPOSE 7101
ENTRYPOINT ["/hibiscus"]