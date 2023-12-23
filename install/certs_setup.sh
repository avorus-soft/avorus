#!/bin/bash

docker compose -f docker-compose-certs.yml build
docker compose -f docker-compose-certs.yml run --rm mkcert
