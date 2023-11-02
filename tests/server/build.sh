#!/usr/bin/env bash

docker buildx build . --output type=docker,name=elestio4test/guacamole-server:latest | docker load