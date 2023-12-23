# Installation

## Prerequisites

[Install Docker Engine](docs/install/INSTALL_DOCKER.md) ([Official Manual](https://docs.docker.com/engine/install/))

## Automagic install

Run this snippet and follow the propmts that appear on screen:

```bash
curl -s https://github.com/avorus-soft/avorus/install/install.sh | bash
```

Once it's done, you should be ready to start Avorus as a daemon by running:

```bash
docker compose up -d
```

Go to https://<hostname> and log in with the credentials of your admin account.

## Manual Install

### 1. Clone repository including submodules

```bash
git clone -j8 --recurse-submodules https://github.com/avorus-soft/avorus
cd avorus
```

### 2. [Set up environment variables](docs/install/ENV_SETUP.md)

```bash
./install/env_setup.sh
```

This will guide you through the enironment setup, which should look something like this:

```bash
# Example
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

### 3. SSL setup

Avorus requires two sets of SSL certificates:

- To serve the API via HTTPS
- To secure the the MQTT broker

Run the `install/ssl_setup.sh` script to generate both sets:

```bash
./install/ssl_setup.sh
```

The generated files can be found in `backend/mkcert/certs`.

HTTPS certificates have a maximum lifetime of [398 days](https://stackoverflow.com/questions/62659149/why-was-398-days-chosen-for-tls-expiration).

The MQTT certificates have no predetermined maximum validity period.

Using the provided script will generate certificates with a validity of ~10 years.

The script uses [FiloSottile/mkcert](https://github.com/FiloSottile/mkcert) and [rabbitmq/tls-gen](https://github.com/rabbitmq/tls-gen). Please refer to these repositories for further information.

### 4. Build images

```bash
docker compose build
```

### 5. User credentials setup

```bash
sudo docker compose run -it --rm api python3 init_user.py
```

```bash
[+] Creating 2/0
 ✔ Container avorus-broker  Running                                       0.0s
 ✔ Container avorus-db      Running                                       0.0s
mongodb://avorus:[...]@localhost:27017/avorus
Creating system user...
User [...] has registered.
User created id=ObjectId('...') revision_id=None email='system@...' hashed_password='...' is_active=True is_superuser=True is_verified=False
Please create your admin account
Email: alex@...
Password (can be changed later):
Verify password:
User [...] has registered.
User created id=ObjectId('...') revision_id=None email='alex@...' hashed_password='...' is_active=True is_superuser=True is_verified=False
Done!
```

### 6. Build UI

The following script will build the React frontend and copy it to the static directory of the API, ready for serving.

It also copies the root certificate authority to the static directory of the API, so you can easily add it as a trusted CA to your system, once the API server is up and running.

```bash
./install/frontend_setup.sh
```

### 7. Deploy!

To start all services in daemon mode:

```bash
docker compose up -d
```

To check out the logs:

```bash
docker compose logs
```
