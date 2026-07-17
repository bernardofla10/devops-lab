# Day 03 - Dockerfile Basics

## Build Image

```bash
docker build -t devops-nginx:day03 .    # Build a Docker image from the Dockerfile in the current directory.
```

## List Images

```bash
docker images                         # List all local Docker images.
docker images | grep devops-nginx     # Filter images by name.
```

## Inspect Image

```bash
docker image inspect devops-nginx:day03              # Display detailed image metadata.
docker image inspect devops-nginx:day03 | head -n 40 # Show the first 40 lines of the image metadata.
docker history devops-nginx:day03                    # Display the image layer history.
```

## Run Container from Custom Image

```bash
docker run -d --name dockerfile-nginx -p 8083:80 devops-nginx:day03   # Run the custom image in a detached container.
```

## Test Container

```bash
curl http://localhost:8083         # Request the application homepage.
curl http://localhost:8083/health  # Test the health endpoint.
curl -I http://localhost:8083      # Retrieve only the HTTP response headers.
```

## List Containers

```bash
docker ps      # List running containers.
docker ps -a   # List all containers.
```

## Logs

```bash
docker logs dockerfile-nginx             # Display the container logs.
docker logs --tail 20 dockerfile-nginx   # Show the last 20 log entries.
docker logs -f dockerfile-nginx          # Follow the logs in real time.
```

## Execute Commands Inside the Container

```bash
docker exec -it dockerfile-nginx sh    # Open an interactive shell inside the running container.
```

Inside the container:

```sh
whoami                              # Display the current user.
hostname                            # Show the container hostname.
pwd                                 # Display the current working directory.
ls -la /usr/share/nginx/html        # List the web root contents.
cat /usr/share/nginx/html/index.html # Display the custom homepage.
cat /etc/nginx/conf.d/default.conf  # Display the Nginx configuration.
exit                                # Exit the container shell.
```

## Rebuild After Changing Files

```bash
docker build -t devops-nginx:day03 .                      # Rebuild the Docker image.

docker rm -f dockerfile-nginx                             # Remove the existing container.

docker run -d --name dockerfile-nginx -p 8083:80 devops-nginx:day03   # Run a new container from the updated image.

curl http://localhost:8083                                # Verify the updated application.
```

## Tag Image

```bash
docker tag devops-nginx:day03 devops-nginx:latest   # Create a new tag for the image.
docker images | grep devops-nginx                   # List the image tags.
docker rmi devops-nginx:latest                      # Remove the image tag.
```

## Run Helper Scripts

```bash
chmod +x build-run-test.sh image-inspect.sh cleanup.sh   # Make the scripts executable.

./build-run-test.sh    # Build, run, and test the Docker image.
./image-inspect.sh     # Display image inspection information.
./cleanup.sh           # Remove lab containers and images.
```

## Remove Container and Image

```bash
docker rm -f dockerfile-nginx    # Stop and remove the container.
docker rmi devops-nginx:day03    # Remove the Docker image.
```