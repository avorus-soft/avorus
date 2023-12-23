# Install Docker Engine

Please refer to the Docker manual for instructions on how to [install Docker Engine](https://docs.docker.com/engine/install/) on your system.

An excerpt from the manual can be found below.

## Debian install using the official Docker apt repository

1. Set up Docker's apt repository.

   ```bash
   # Add Docker's official GPG key:
   sudo apt-get update
   sudo apt-get install ca-certificates curl gnupg
   sudo install -m 0755 -d /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   sudo chmod a+r /etc/apt/keyrings/docker.gpg

   # Add the repository to Apt sources:
   echo \
     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
     $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
     sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt-get update
   ```

2. Install the Docker packages.

   ```bash
   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
   ```

3. Verify that the installation is successful by running the hello-world image:

   ```bash
   sudo docker run hello-world
   ```

4. Perform the [post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/).
