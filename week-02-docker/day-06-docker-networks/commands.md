# Day 06 - Docker Networks

## List Networks

```bash
docker network ls                                 # List all Docker networks.
docker network inspect bridge                     # Display detailed information about the default bridge network.
docker network inspect bridge | head -n 80        # Show the first 80 lines of the bridge network configuration.
```

## Build Images

```bash
docker build -f Dockerfile.api -t devops-network-api:day06 .        # Build the API image using Dockerfile.api.
docker build -f Dockerfile.client -t devops-network-client:day06 .  # Build the client image using Dockerfile.client.
docker images | grep devops-network                                 # List the Docker images created for this lab.
```

## Host to Container Access

```bash
docker rm -f api-day06 2>/dev/null || true    # Remove the previous API container if it exists.

docker run -d \                               # Run the API container in detached mode.
  --name api-day06 \                          # Assign a container name.
  -p 8087:3000 \                              # Map host port 8087 to container port 3000.
  -e APP_NAME=api-day06 \                     # Set the application name.
  -e APP_ENV=host-access \                    # Set the application environment.
  devops-network-api:day06                    # Specify the image to run.

curl http://localhost:8087         # Request the application homepage.
curl http://localhost:8087/health  # Test the health endpoint.
curl http://localhost:8087/info    # Display application information.

docker logs api-day06              # Display the container logs.
```

## Create a Custom Network

```bash
docker network create devops-net-day06      # Create a custom bridge network.
docker network ls                           # List all Docker networks.
docker network inspect devops-net-day06     # Display detailed network information.
```

## API and Client in the Same Network

```bash
docker rm -f api-day06 2>/dev/null || true    # Remove the previous API container.

docker run -d \                               # Run the API container.
  --name api-day06 \                          # Assign a container name.
  --network devops-net-day06 \                # Connect the container to the custom network.
  -p 8087:3000 \                              # Map the host port.
  -e APP_NAME=api-day06 \                     # Set the application name.
  -e APP_ENV=custom-network \                 # Set the application environment.
  devops-network-api:day06                    # Specify the image to run.

docker run --rm \                             # Run a temporary client container.
  --name client-day06 \                       # Assign a container name.
  --network devops-net-day06 \                # Connect to the custom network.
  -e TARGET_URL=http://api-day06:3000/health \ # Set the target URL.
  devops-network-client:day06                 # Specify the client image.

docker run --rm \                             # Run another temporary client container.
  --name client-day06-info \                  # Assign a container name.
  --network devops-net-day06 \                # Connect to the custom network.
  -e TARGET_URL=http://api-day06:3000/info \  # Set the target URL.
  devops-network-client:day06                 # Specify the client image.
```

## Localhost Test from Inside a Container

```bash
docker run --rm \                                      # Run a temporary client container.
  --name client-localhost-test \                       # Assign a container name.
  --network devops-net-day06 \                         # Connect to the custom network.
  -e TARGET_URL=http://localhost:3000/health \         # Attempt to access localhost from inside the container.
  devops-network-client:day06                          # Specify the client image.
```

## Network Isolation

```bash
docker network create isolated-net-day06      # Create an isolated Docker network.

docker run --rm \                             # Run a temporary client container.
  --name client-isolated \                    # Assign a container name.
  --network isolated-net-day06 \              # Connect to the isolated network.
  -e TARGET_URL=http://api-day06:3000/health \ # Attempt to reach the API.
  devops-network-client:day06                 # Specify the client image.
```

## Connect and Disconnect Networks

```bash
docker network connect isolated-net-day06 api-day06    # Connect the API container to another network.

docker run --rm \                                      # Run a temporary client container.
  --name client-isolated \                             # Assign a container name.
  --network isolated-net-day06 \                       # Connect to the isolated network.
  -e TARGET_URL=http://api-day06:3000/health \         # Test connectivity.
  devops-network-client:day06                          # Specify the client image.

docker network disconnect isolated-net-day06 api-day06 # Disconnect the API container from the network.
```

## Inspect Network and Container

```bash
docker network inspect devops-net-day06                     # Display detailed network information.
docker network inspect devops-net-day06 | grep -A 30 Containers   # Display the connected containers.

docker port api-day06                                       # Display the container port mappings.

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' api-day06   # Display the container IP address.

docker logs --tail 20 api-day06                             # Show the last 20 container log entries.
```

## Run Helper Scripts

```bash
chmod +x scripts/*.sh          # Make all helper scripts executable.

./scripts/build-images.sh      # Build the Docker images.
./scripts/default-bridge-lab.sh # Demonstrate the default bridge network.
./scripts/custom-network-lab.sh # Demonstrate custom Docker networks.
./scripts/network-isolation-lab.sh # Demonstrate network isolation.
./scripts/inspect-network.sh   # Display Docker network information.
./scripts/cleanup.sh           # Remove lab containers and networks.
```