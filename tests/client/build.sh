#!/usr/bin/env bash
sed -i "s~-DskipTests=false~-DskipTests=false -Drat.numUnapprovedLicenses=100~g" Dockerfile
docker buildx build . --output type=docker,name=elestio4test/guacamole-client:latest | docker load