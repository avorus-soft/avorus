# Setup environment variables

This repo uses docker-compose to orchestrate container setup and health checks.

It requires a `.env` file in the root of the repository, right next to the `docker-compose.yml`.

## Automatic setup

A bash script to guide you though the setup of the required variables is provided:

[install/env_setup.sh](/install/env_setup.sh)

This bash script will:

1. Generate random strings for internal passwords and the FastAPI Users JWT secret.
2. Get the fully qualified domain name (FQDN) of the system running the script.
3. Prompt the user for the NetBox URL, username, password.
4. Provision the API token from NetBox.
5. Create a .env file from .env.example.
6. Replace the placeholders in the .env file with the actual values, including the generated random strings and FQDN.
7. Alert the user if the NetBox API token can't be provisioned, or confirm that the .env file has been created successfully.

Before running this script, make sure you have the required packages installed:

<details>
   <summary>Debian/Ubuntu</summary>

```bash
sudo apt update
sudo apt install curl jq
```

</details>

- curl
- jq

Run the script from the root of this repository:

```bash
# Example
./install/env_setup.sh

Enter the URL of the NetBox instance (e.g., 'https://netbox.example.com'): http://localhost:8000
Enter your NetBox username: avm
Enter your NetBox password: ****
Enter KNX Gateway IP: 1.2.3.4
Enter path to knxkeys file (exported from ETS): /opt/knxkeys.knxkeys
Enter knxkeys password: ****
Enter PJLink password: ****
NetBox Token provisioned successfully.
.env file has been created.
```

## Manual setup

Alternatively, a `.env.example` is provided. Start with this file to set up the required environment variables.

```bash
cp .env.example .env
```

```bash
# Hostname of the Avorus Mongodb server
# MONGO_INITDB_HOSTNAME=
# Name for the Mongodb database
# MONGO_INITDB_DATABASE=
# Username for the Mongodb database
# MONGO_INITDB_USERNAME=
# Password for the Mongodb database
# MONGO_INITDB_PASSWORD=

# Hostname of the server that is running the MQTT broker
# MQTT_HOSTNAME=

# Hostname of the Avorus API server
# API_HOSTNAME=
# FastAPI Users Secret
# API_SECRET=
# API_ROOT_CA=./backend/mkcert/certs/.local/share/mkcert/rootCA.pem
# API_SYSTEM_USERNAME=
# API_SYSTEM_PASSWORD=

# NETBOX_API_URL=
# NETBOX_API_TOKEN=

# KNX_GATEWAY_IP=
# Path to knxkeys file, exported from ETS
# KNXKEYS_FILE_PATH=
# KNXKEYS_PASSWORD=

# PJLINK_PASSWORD=
```
