#!/bin/bash

# Initialize a flag to determine if we are inside the 'avorus' repo
inside_avorus_repo=false

# Check if we're in the 'avorus' repo
if [ -f "install/install.sh" ]; then
  inside_avorus_repo=true
fi

if [ "$inside_avorus_repo" = false ]; then
  git clone -j8 --recurse-submodules https://github.com/avorus-soft/avorus
  cd avorus || exit
fi

# Define function to check and touch flag files
check_and_touch() {
  if [ ! -f "$1" ]; then
    $2 && touch "$1"
  else
    echo "Skipping step, $1 exists."
  fi
}

check_and_touch "env_setup.flag" "./install/env_setup.sh"
check_and_touch "ssl_setup.flag" "./install/ssl_setup.sh"
check_and_touch "docker_build.flag" "docker compose build"
check_and_touch "init_user.flag" "docker compose run -it --rm api python3 init_user.py"

# Set up the frontend
check_and_touch "frontend_setup.flag" "./install/frontend_setup.sh"
