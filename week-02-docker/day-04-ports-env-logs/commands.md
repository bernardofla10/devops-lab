# Day 04 - Docker Ports, Environment Variables and Logs

## Build Image

```bash
docker build -t devops-env-app:day04 .    # Build a Docker image from the Dockerfile.
```

## Run with Environment Variables

```bash
docker run -d \                            # Run the container in detached mode.
  --name env-app-day04 \                   # Assign a name to the container.
  -p 8084:3000 \                           # Map host port 8084 to container port 3000.
  -e APP_NAME=devops-env-app \             # Set the APP_NAME environment variable.
  -e APP_ENV=development \                 # Set the APP_ENV environment variable.
  -e APP_MESSAGE="Hello from docker run environment variables" \   # Set a custom application message.
  -e PORT=3000 \                           # Set the application port.
  devops-env-app:day04                     # Specify the image to run.
```

## Test Endpoints

```bash
curl http://localhost:8084         # Request the application homepage.
curl http://localhost:8084/health  # Test the health endpoint.
curl http://localhost:8084/config  # Display the application configuration.
curl http://localhost:8084/error   # Trigger an error endpoint for testing.
```

## Check Containers

```bash
docker ps      # List running containers.
docker ps -a   # List all containers.
```

## Check Port Mappings

```bash
docker port env-app-day04                                   # Display the container port mappings.
docker inspect -f '{{json .NetworkSettings.Ports}}' env-app-day04   # Display detailed port mapping information.
```

## Test Wrong Port

```bash
curl http://localhost:3000    # Attempt to access the application on the wrong host port.
```

## Test Port Conflict

```bash
docker run -d \                           # Attempt to start another container.
  --name env-app-conflict \               # Assign a container name.
  -p 8084:3000 \                          # Reuse the same host port (expected to fail).
  devops-env-app:day04                    # Specify the image to run.
```

## Run a Second Container on Another Host Port

```bash
docker run -d \                           # Run another container in detached mode.
  --name env-app-day04-b \                # Assign a different container name.
  -p 8085:3000 \                          # Map host port 8085 to container port 3000.
  -e APP_NAME=devops-env-app-b \          # Set the application name.
  -e APP_ENV=test \                       # Set the environment.
  -e APP_MESSAGE="Hello from second container" \   # Set a custom message.
  devops-env-app:day04                    # Specify the image to run.

curl http://localhost:8085/config         # Verify the second container configuration.
```

## Run with an Environment File

```bash
docker rm -f env-app-day04 env-app-day04-b env-app-conflict 2>/dev/null || true   # Remove existing containers if they exist.

docker run -d \                           # Run the container in detached mode.
  --name env-app-day04 \                  # Assign a container name.
  -p 8084:3000 \                          # Map the host port.
  --env-file .env \                       # Load environment variables from a file.
  devops-env-app:day04                    # Specify the image to run.

curl http://localhost:8084/config         # Verify the loaded environment variables.
```

## Inspect Environment Variables

```bash
docker inspect -f '{{json .Config.Env}}' env-app-day04                 # Display environment variables in JSON format.
docker inspect -f '{{range .Config.Env}}{{println .}}{{end}}' env-app-day04   # Display one environment variable per line.
```

## Logs

```bash
docker logs env-app-day04                           # Display all container logs.
docker logs --tail 10 env-app-day04                 # Show the last 10 log entries.
docker logs -f env-app-day04                        # Follow logs in real time.
docker logs --since 5m env-app-day04                # Display logs from the last 5 minutes.
docker logs -t env-app-day04                        # Display logs with timestamps.
docker logs env-app-day04 2>&1 | grep simulated     # Search the logs for the word "simulated".
```

## Execute Commands Inside the Container

```bash
docker exec -it env-app-day04 sh    # Open an interactive shell inside the container.
```

Inside the container:

```sh
pwd                   # Display the current working directory.
ls -la                # List files with detailed information.
printenv | sort       # Display all environment variables in alphabetical order.
printenv APP_NAME     # Display the APP_NAME variable.
printenv APP_ENV      # Display the APP_ENV variable.
printenv APP_MESSAGE  # Display the APP_MESSAGE variable.
printenv PORT         # Display the PORT variable.
cat server.js | head  # Display the first lines of the application source code.
exit                  # Exit the container shell.
```

## Run Helper Scripts

```bash
chmod +x build-run-env-lab.sh logs-test.sh inspect-container.sh cleanup.sh   # Make the scripts executable.

./build-run-env-lab.sh     # Build and run the environment variables lab.
./logs-test.sh             # Generate logs for testing.
./inspect-container.sh     # Display container inspection information.
./cleanup.sh               # Remove lab containers and resources.
```