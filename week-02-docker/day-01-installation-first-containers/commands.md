# Day 01 - Docker Installation and First Containers

## Check Docker

```bash
docker --version    # Display the installed Docker version.
docker version      # Show Docker client and server version information.
docker info         # Display detailed Docker system information.
```

## Install Docker Engine on Ubuntu

```bash
sudo apt update                                         # Update the package index.
sudo apt install ca-certificates curl -y                # Install required dependencies.

sudo install -m 0755 -d /etc/apt/keyrings               # Create the directory for APT keyrings.

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc   # Download Docker's GPG key.

sudo chmod a+r /etc/apt/keyrings/docker.asc             # Allow APT to read the GPG key.

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF   # Add the official Docker repository.
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update                                         # Refresh the package index.

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y   # Install Docker Engine and related tools.
```

## Manage Docker Service

```bash
sudo systemctl status docker     # Show the Docker service status.
sudo systemctl start docker      # Start the Docker service.
sudo systemctl restart docker    # Restart the Docker service.
```

## Optional: Run Docker Without sudo

```bash
sudo groupadd docker             # Create the Docker group (if it does not exist).
sudo usermod -aG docker $USER    # Add the current user to the Docker group.
newgrp docker                    # Apply the new group membership without logging out.

docker run hello-world           # Verify Docker works without sudo.
```

## First Container

```bash
docker run hello-world    # Run the official Hello World container.
```

## Alpine Container

```bash
docker run alpine:latest echo "Hello from Alpine"   # Run a command inside an Alpine container.
docker run -it alpine:latest sh                     # Start an interactive Alpine shell.
```

Inside the container:

```sh
whoami               # Display the current user.
hostname             # Show the container hostname.
cat /etc/os-release  # Display the operating system information.
ls -la               # List files with detailed information.
pwd                  # Show the current working directory.
exit                 # Exit the container shell.
```

## Container Lifecycle

```bash
docker ps      # List running containers.
docker ps -a   # List all containers.
docker images  # List downloaded Docker images.
```

## Nginx Container

```bash
docker pull nginx:alpine                             # Download the Nginx Alpine image.

docker run -d --name nginx-day01 -p 8081:80 nginx:alpine   # Run the Nginx container in the background.

curl http://localhost:8081      # Fetch the default Nginx page.
curl -I http://localhost:8081   # Retrieve only the HTTP response headers.

docker ps                       # Verify that the container is running.
docker logs nginx-day01         # Display the container logs.
docker logs -f nginx-day01      # Follow the container logs in real time.
```

## Execute Commands Inside a Container

```bash
docker exec -it nginx-day01 sh   # Open an interactive shell inside the running container.
```

Inside the container:

```sh
whoami                                         # Display the current user.
hostname                                       # Show the container hostname.
ls -la /usr/share/nginx/html                   # List the default web files.
cat /usr/share/nginx/html/index.html | head    # Display the first lines of the default web page.
exit                                           # Exit the container shell.
```

## Stop, Start, and Remove

```bash
docker stop nginx-day01    # Stop the container.
docker start nginx-day01   # Start the container.
docker rm nginx-day01      # Remove the stopped container.
```

## Remove Forcefully

```bash
docker rm -f nginx-day01   # Forcefully stop and remove the container.
```

## Run Lab Scripts

```bash
chmod +x docker-run-lab.sh docker-health-check.sh container-cleanup.sh   # Make the scripts executable.

./docker-run-lab.sh        # Run the Docker lab script.
./docker-health-check.sh   # Check the health of the Docker containers.
./container-cleanup.sh     # Remove lab containers and resources.
```