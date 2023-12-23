#!/bin/bash

git clone -j8 --recurse-submodules https://github.com/avorus-soft/avorus
cd avorus

./install/env_setup.sh
./install/ssl_setup.sh
docker compose build
sudo docker compose run -it --rm api python3 init_user.py
./install/frontend_setup.sh
