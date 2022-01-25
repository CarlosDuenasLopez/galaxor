#!/usr/bin/env sh

set -eu

# Update the system
apk update && apk upgrade

# Install java + maven
apk add openjdk17-jdk
apk add maven

# install docker-compose:
apk add docker-compose
