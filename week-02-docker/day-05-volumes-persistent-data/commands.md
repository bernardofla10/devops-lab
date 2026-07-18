# Day 05 - Docker Volumes and Persistent Data

## Build Image

```bash
docker build -t devops-volumes-app:day05 .    # Build a Docker image from the Dockerfile.
```

## Run Without a Volume

```bash
docker rm -f volumes-ephemeral 2>/dev/null || true    # Remove the previous container if it exists.

docker run -d \                                       # Run the container in detached mode.
  --name volumes-ephemeral \                          # Assign a name to the container.
  -p 8086:3000 \                                      # Map host port 8086 to container port 3000.
  -e APP_NAME=volumes-ephemeral \                     # Set the application name.
  -e APP_ENV=ephemeral \                              # Set the application environment.
  devops-volumes-app:day05                            # Specify the image to run.

curl http://localhost:8086/health                              # Test the health endpoint.
curl "http://localhost:8086/write?message=first-ephemeral-message"   # Write a message to the application.
curl http://localhost:8086/data                                # Display the stored data.

docker rm -f volumes-ephemeral                                 # Remove the container.
```

## Named Volume

```bash
docker volume create devops-data-day05      # Create a named Docker volume.
docker volume ls                            # List all Docker volumes.
docker volume inspect devops-data-day05     # Display detailed volume information.
```

```bash
docker run -d \                             # Run the container in detached mode.
  --name volumes-named \                    # Assign a container name.
  -p 8086:3000 \                            # Map host port 8086 to container port 3000.
  -e APP_NAME=volumes-named \               # Set the application name.
  -e APP_ENV=named-volume \                 # Set the application environment.
  -v devops-data-day05:/data \              # Mount the named volume into the container.
  devops-volumes-app:day05                  # Specify the image to run.

curl "http://localhost:8086/write?message=first-named-volume-message"    # Write the first message.
curl "http://localhost:8086/write?message=second-named-volume-message"   # Write the second message.
curl http://localhost:8086/data                                         # Display the persisted data.

docker rm -f volumes-named                                               # Remove the container.
```

## Recreate the Container with the Same Volume

```bash
docker run -d \                                 # Run a new container.
  --name volumes-named \                        # Assign the container name.
  -p 8086:3000 \                                # Map the host port.
  -e APP_NAME=volumes-named-recreated \         # Set the application name.
  -e APP_ENV=named-volume \                     # Set the application environment.
  -v devops-data-day05:/data \                  # Reuse the existing named volume.
  devops-volumes-app:day05                      # Specify the image to run.

curl http://localhost:8086/data                 # Verify that the data was preserved.
```

## Bind Mount

```bash
docker rm -f volumes-named      # Remove the previous container.
mkdir -p host-data              # Create a directory on the host.

docker run -d \                             # Run the container in detached mode.
  --name volumes-bind \                     # Assign the container name.
  -p 8086:3000 \                            # Map the host port.
  -e APP_NAME=volumes-bind \                # Set the application name.
  -e APP_ENV=bind-mount \                   # Set the application environment.
  -v "$PWD/host-data:/data" \               # Mount the host directory into the container.
  devops-volumes-app:day05                  # Specify the image to run.

curl "http://localhost:8086/write?message=first-bind-mount-message"      # Write the first message.
curl "http://localhost:8086/write?message=second-bind-mount-message"     # Write the second message.
curl http://localhost:8086/data                                          # Display the stored data.

ls -la host-data                 # List the files created on the host.
cat host-data/messages.json      # Display the persisted data file.
```

## Inspect Mounts

```bash
docker inspect -f '{{json .Mounts}}' volumes-bind      # Display mount information in JSON format.
docker inspect volumes-bind | grep -A 20 Mounts        # Display the mount configuration.
docker logs --tail 20 volumes-bind                     # Show the last 20 container log entries.
docker top volumes-bind                                # Display running processes inside the container.
```

## Run Helper Scripts

```bash
chmod +x scripts/*.sh              # Make all helper scripts executable.

./scripts/build-image.sh           # Build the Docker image.
./scripts/ephemeral-data-lab.sh    # Demonstrate ephemeral container storage.
./scripts/named-volume-lab.sh      # Demonstrate named volume persistence.
./scripts/bind-mount-lab.sh        # Demonstrate bind mounts.
./scripts/inspect-volumes.sh       # Display volume information.
./scripts/cleanup.sh               # Remove lab resources.
```

## Remove the Named Volume

```bash
docker volume rm devops-data-day05    # Remove the named Docker volume.
```

## Remove Bind Mount Data

```bash
rm -rf host-data    # Delete the host directory used for the bind mount.
```