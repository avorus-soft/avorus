#!/bin/bash

# Define the expected Git repository URL
REPO_URL="https://github.com/avorus-soft/avorus"

# Check whether .git/config exists and contains the expected URL
if [ -d ".git" ] && grep -q "$REPO_URL" .git/config; then
  inside_avorus_repo=true
else
  inside_avorus_repo=false
fi


if [ "$inside_avorus_repo" = false ]; then
  git clone -j8 --recurse-submodules https://github.com/avorus-soft/avorus
  cd avorus || exit
fi

scripts=("./install/env_setup.sh" "./install/ssl_setup.sh" "./install/docker_build.sh" "./install/setup_user.sh" "./install/frontend_setup.sh")

for script in "${scripts[@]}"; do
  # Check if the script has been executed successfully in a previous run
  flag_file="${script}.done"

  if [ ! -e "$flag_file" ]; then
    read -p "Do you want to run $script interactively? (y/n): " -n 1 -r
    echo # Move to a new line

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      # Run the script interactively
      if ./"$script"; then
        # Only create the flag file if the script executed successfully
        touch "$flag_file"
      else
        echo "$script failed. Exiting the installation."
        exit 1
      fi
    else
      echo "Skipping $script..."
    fi
  else
    echo "$script has already been run successfully."
  fi
done

echo "Done!"

