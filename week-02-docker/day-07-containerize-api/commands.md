# Day 07 - Containerize a Simple API

## Build

```bash
docker build -t devops-api:week02-final .    # Build the Docker image from the Dockerfile.
```

## Create Network and Volume

```bash
docker network create devops-api-net-day07    # Create a custom Docker network.
docker volume create devops-api-data-day07    # Create a named Docker volume for persistent data.
```

## Run

```bash
docker run -d \                               # Run the container in detached mode.
  --name devops-api-day07 \                   # Assign a container name.
  --network devops-api-net-day07 \            # Connect the container to the custom network.
  -p 8088:3000 \                              # Map host port 8088 to container port 3000.
  --env-file .env \                           # Load environment variables from the .env file.
  -v devops-api-data-day07:/data \            # Mount the named volume into the container.
  devops-api:week02-final                     # Specify the image to run.
```

## Test Endpoints

```bash
curl http://localhost:8088                                               # Request the application homepage.
curl http://localhost:8088/health                                        # Test the health endpoint.
curl http://localhost:8088/config                                        # Display the application configuration.
curl http://localhost:8088/items                                         # List persisted items.
curl "http://localhost:8088/items/add?title=first-docker-final-item"     # Add the first item.
curl "http://localhost:8088/items/add?title=second-docker-final-item"    # Add the second item.
curl http://localhost:8088/items                                         # Verify the persisted items.
curl http://localhost:8088/error                                         # Trigger a simulated error for logging.
```

## Logs

```bash
docker logs devops-api-day07                           # Display all container logs.
docker logs --tail 20 devops-api-day07                 # Show the last 20 log entries.
docker logs -t --tail 20 devops-api-day07              # Show the last 20 log entries with timestamps.
docker logs -f devops-api-day07                        # Follow the logs in real time.
docker logs devops-api-day07 2>&1 | grep simulated     # Search the logs for simulated errors.
```

## Health Check

```bash
docker ps                                                    # List running containers.
docker inspect -f '{{json .State.Health}}' devops-api-day07  # Display the container health status.
docker inspect devops-api-day07 | grep -A 40 Health          # Display detailed health check information.
```

## Volume Persistence

```bash
curl http://localhost:8088/items    # Display the persisted items.

docker rm -f devops-api-day07       # Stop and remove the container.

docker run -d \                               # Run a new container.
  --name devops-api-day07 \                   # Assign the container name.
  --network devops-api-net-day07 \            # Connect to the custom network.
  -p 8088:3000 \                              # Map the host port.
  --env-file .env \                           # Load environment variables.
  -v devops-api-data-day07:/data \            # Reuse the named volume.
  devops-api:week02-final                     # Specify the image to run.

curl http://localhost:8088/items              # Verify that the data was preserved.
```

## Network Test

```bash
docker run --rm \                                               # Run a temporary container.
  --network devops-api-net-day07 \                              # Connect to the custom network.
  node:20-alpine \                                              # Use the Node.js Alpine image.
  node -e "require('http').get('http://devops-api-day07:3000/health', res => { let d=''; res.on('data', c => d+=c); res.on('end', () => { console.log(d); process.exit(res.statusCode === 200 ? 0 : 1); }); }).on('error', err => { console.error(err.message); process.exit(1); })"   # Test API connectivity from another container.
```

## Execute Commands Inside the Container

```bash
docker exec -it devops-api-day07 sh    # Open an interactive shell inside the running container.
```

Inside the container:

```sh
pwd                  # Display the current working directory.
ls -la               # List files with detailed information.
printenv | sort      # Display all environment variables.
ls -la /data         # List the persisted data directory.
cat /data/items.json # Display the persisted data file.
exit                 # Exit the container shell.
```

## Inspect the Container

```bash
docker top devops-api-day07                                                    # Display the running processes.
docker stats --no-stream devops-api-day07                                      # Display a snapshot of resource usage.
docker inspect -f '{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}' devops-api-day07   # Display the container IP address.
docker inspect -f '{{json .Mounts}}' devops-api-day07                          # Display the mounted volumes.
```

## Helper Scripts

```bash
chmod +x scripts/*.sh    # Make all helper scripts executable.

./scripts/build.sh        # Build the Docker image.
./scripts/run.sh          # Run the application container.
./scripts/test.sh         # Test the API endpoints.
./scripts/logs.sh         # Display the application logs.
./scripts/inspect.sh      # Display container inspection information.
./scripts/network-lab.sh  # Demonstrate Docker networking.
./scripts/volume-lab.sh   # Demonstrate volume persistence.
./scripts/cleanup.sh      # Remove lab containers, networks, and volumes.
```