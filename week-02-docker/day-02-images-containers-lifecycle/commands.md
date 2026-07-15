# Day 02 - Docker Images, Containers and Lifecycle

## Images

```bash
docker images                                   # List all local Docker images.
docker images -q                                # Display only image IDs.
docker pull nginx:alpine                        # Download the Nginx Alpine image.
docker pull alpine:latest                       # Download the latest Alpine image.
docker image inspect nginx:alpine               # Display detailed image metadata.
docker image inspect nginx:alpine | head -n 40  # Show the first 40 lines of the image metadata.
```

## Create vs Run

```bash
docker create --name lifecycle-nginx -p 8082:80 nginx:alpine   # Create a container without starting it.

docker ps       # List running containers.
docker ps -a    # List all containers.

docker start lifecycle-nginx    # Start the existing container.

docker ps       # Verify that the container is running.

curl -I http://localhost:8082   # Test the web server by requesting the HTTP headers.
```

## Container State

```bash
docker inspect lifecycle-nginx                           # Display detailed container information.
docker inspect -f '{{.State.Status}}' lifecycle-nginx    # Display only the container status.
```

## Pause and Unpause

```bash
docker pause lifecycle-nginx                             # Pause all processes inside the container.
docker ps                                                # List running containers.
docker inspect -f '{{.State.Status}}' lifecycle-nginx    # Verify the container state.

curl -I --max-time 3 http://localhost:8082               # Test the service with a timeout.

docker unpause lifecycle-nginx                           # Resume the paused container.
curl -I http://localhost:8082                            # Verify the service is responding again.
```

## Stop, Start, and Restart

```bash
docker stop lifecycle-nginx                             # Stop the container.
docker ps                                               # List running containers.
docker ps -a                                            # List all containers.
docker inspect -f '{{.State.Status}}' lifecycle-nginx   # Verify the container state.

docker start lifecycle-nginx                            # Start the container.
docker restart lifecycle-nginx                          # Restart the container.

curl -I http://localhost:8082                           # Verify the web server is responding.
```

## Logs, Processes, and Stats

```bash
docker logs lifecycle-nginx                # Display the container logs.

curl http://localhost:8082                 # Request the default web page.
curl http://localhost:8082/teste           # Request a non-existent page.
curl -I http://localhost:8082              # Retrieve only the HTTP response headers.

docker logs --tail 20 lifecycle-nginx      # Show the last 20 log entries.
docker top lifecycle-nginx                 # Display the running processes inside the container.
docker stats lifecycle-nginx               # Monitor container resource usage in real time.
docker stats --no-stream lifecycle-nginx   # Display a single resource usage snapshot.
```

## Copy Files with `docker cp`

```bash
echo "Hello from host machine" > host-file.txt      # Create a file on the host.

docker cp host-file.txt lifecycle-nginx:/tmp/host-file.txt   # Copy the file into the container.

docker exec -it lifecycle-nginx sh                  # Open a shell inside the container.

cat /tmp/host-file.txt                              # Display the copied file.
exit                                                # Exit the container shell.

docker cp lifecycle-nginx:/usr/share/nginx/html/index.html ./container-index.html   # Copy a file from the container.

head container-index.html                           # Display the first lines of the copied file.

rm host-file.txt container-index.html               # Remove the temporary files.
```

## Rename and Remove

```bash
docker rename lifecycle-nginx lifecycle-nginx-renamed   # Rename the container.

docker ps                                               # Verify the new container name.

curl -I http://localhost:8082                           # Verify the service is still available.

docker stop lifecycle-nginx-renamed                     # Stop the renamed container.
docker rm lifecycle-nginx-renamed                       # Remove the container.

docker ps -a                                            # Verify that the container has been removed.
```

## Temporary Alpine Container

```bash
docker run --name alpine-test alpine:latest echo "Hello from Alpine"   # Run a temporary command inside an Alpine container.

docker ps       # List running containers.
docker ps -a    # List all containers.

docker run --rm alpine:latest echo "This container will be automatically removed"   # Run and automatically remove the container after exit.

docker ps -a    # Verify that the temporary container was removed.
```

## Interactive Alpine Container

```bash
docker run -it --name alpine-interactive alpine:latest sh   # Start an interactive Alpine shell.
```

Inside the container:

```sh
whoami               # Display the current user.
hostname             # Show the container hostname.
pwd                  # Display the current working directory.
ls -la               # List files with detailed information.
cat /etc/os-release  # Display the operating system information.
exit                 # Exit the container shell.
```

Remove:

```bash
docker rm alpine-interactive    # Remove the stopped Alpine container.
```

## Lab Scripts

```bash
chmod +x container-lifecycle-lab.sh container-inspect-report.sh docker-cleanup-lifecycle.sh   # Make the scripts executable.

./container-lifecycle-lab.sh     # Run the container lifecycle lab.
./container-inspect-report.sh    # Generate a container inspection report.
./docker-cleanup-lifecycle.sh    # Remove lab containers and resources.
```