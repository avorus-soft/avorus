#!/bin/bash

# Generate a 32 character random string
generate_random_string() {
  cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 32
}

# Get the FQDN of the system running the script
fqdn=$(hostname -f)

# Prompt user for specific values
read -p "Enter the URL of the NetBox instance (e.g., 'https://netbox.example.com'): " netbox_url
read -p "Enter your NetBox username: " username
read -s -p "Enter your NetBox password: " password
echo
read -p "Enter KNX Gateway IP: " knx_gateway_ip
read -p "Enter path to knxkeys file (exported from ETS): " knxkeys_file_path
read -s -p "Enter knxkeys password: " knxkeys_password
echo
read -s -p "Enter PJLink password: " pjlink_password
echo

# Provision NetBox API Token
response=$(curl -k -s -X POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json; indent=4" \
  -d "{\"username\": \"${username}\", \"password\": \"${password}\"}" \
  "${netbox_url}/api/users/tokens/provision/")

token=$(echo $response | jq -r '.key')

# Check the NetBox token provisioning result
if [ -n "$token" ] && [ "$token" != "null" ]; then
  echo "NetBox Token provisioned successfully."
else
  echo "Failed to provision NetBox token with provided credentials or to parse the token."
  echo $response
  exit 1
fi

# Create .env file from .env.example
cp .env.example .env

# Replace placeholders with actual values
sed -i "s|# MONGO_INITDB_HOSTNAME=|MONGO_INITDB_HOSTNAME=${fqdn}|g" .env
sed -i "s|# MONGO_INITDB_DATABASE=avorus|MONGO_INITDB_DATABASE=avorus|g" .env
sed -i "s|# MONGO_INITDB_USERNAME=avorus|MONGO_INITDB_USERNAME=avorus|g" .env
sed -i "s|# MONGO_INITDB_PASSWORD=|MONGO_INITDB_PASSWORD=$(generate_random_string)|g" .env
sed -i "s|# MQTT_HOSTNAME=|MQTT_HOSTNAME=${fqdn}|g" .env
sed -i "s|# API_HOSTNAME=|API_HOSTNAME=${fqdn}|g" .env
sed -i "s|# API_SECRET=|API_SECRET=$(generate_random_string)|g" .env
sed -i "s|# API_SYSTEM_USERNAME=|API_SYSTEM_USERNAME=system@${fqdn}|g" .env
sed -i "s|# API_SYSTEM_PASSWORD=|API_SYSTEM_PASSWORD=$(generate_random_string)|g" .env
sed -i "s|# NETBOX_API_URL=|NETBOX_API_URL=${netbox_url}|g" .env
sed -i "s|# NETBOX_API_TOKEN=|NETBOX_API_TOKEN=${token}|g" .env
sed -i "s|# KNX_GATEWAY_IP=|KNX_GATEWAY_IP=${knx_gateway_ip}|g" .env
sed -i "s|# KNXKEYS_FILE_PATH=|KNXKEYS_FILE_PATH=${knxkeys_file_path}|g" .env
sed -i "s|# KNXKEYS_PASSWORD=|KNXKEYS_PASSWORD=${knxkeys_password}|g" .env
sed -i "s|# PJLINK_PASSWORD=|PJLINK_PASSWORD=${pjlink_password}|g" .env

echo ".env file has been created."
