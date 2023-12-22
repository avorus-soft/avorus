#!/bin/bash

set -a
source .env
set +a
envsubst < docker-compose.yml | docker stack deploy -c - $STACKNAME
