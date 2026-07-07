# Day 04 - Linux Services and Logs

## Checking systemd

```bash
systemctl status    # Display the overall system and systemd status.
```

## Listing Services

```bash
systemctl list-units --type=service --state=running    # List all running services.
systemctl list-units --type=service                    # List all loaded services.
```

## Checking Service Status

```bash
systemctl status ssh        # Show the status of the SSH service.
systemctl status sshd       # Show the status of the SSH daemon (depends on the distribution).
systemctl status fake-app   # Check the status of the custom service.
```

## Reading Service Logs

```bash
journalctl -u ssh                      # Display all logs for the SSH service.
journalctl -u ssh -n 20                # Show the last 20 log entries.
journalctl -u ssh -f                   # Follow new log entries in real time.

journalctl -u fake-app                 # Display all logs for the fake-app service.
journalctl -u fake-app -n 20           # Show the last 20 log entries.
journalctl -u fake-app -n 50 --no-pager # Show the last 50 log entries without pagination.
journalctl -u fake-app -f              # Follow new log entries in real time.
journalctl -u fake-app -b              # Show logs since the last system boot.
```

## Creating a systemd Service

```bash
chmod +x fake-app.sh                                 # Make the script executable.
realpath fake-app.sh                                 # Display the script's absolute path.

sudo cp fake-app.service /etc/systemd/system/fake-app.service  # Copy the service file to the systemd directory.
sudo systemctl daemon-reload                         # Reload systemd to detect new service files.
sudo systemctl start fake-app                        # Start the fake-app service.
systemctl status fake-app                            # Check the service status.
```

## Managing a Service

```bash
sudo systemctl start fake-app      # Start the service.
sudo systemctl stop fake-app       # Stop the service.
sudo systemctl restart fake-app    # Restart the service.
systemctl status fake-app          # Display the service status.
```

## Enable or Disable Service at Boot

```bash
sudo systemctl enable fake-app     # Enable the service to start automatically at boot.
systemctl is-enabled fake-app      # Check whether the service is enabled.

sudo systemctl disable fake-app    # Disable automatic startup at boot.
systemctl is-enabled fake-app      # Verify whether the service is disabled.
```

## Debugging Service Failures

```bash
systemctl status fake-app                     # Check the current service status.
journalctl -u fake-app -n 30 --no-pager       # Display the last 30 log entries.
sudo systemctl daemon-reload                  # Reload systemd after service file changes.
sudo systemctl restart fake-app               # Restart the service after applying changes.
```

## Removing the Lab Service

```bash
sudo systemctl stop fake-app                  # Stop the service.
sudo systemctl disable fake-app               # Disable automatic startup.
sudo rm /etc/systemd/system/fake-app.service  # Remove the service definition file.
sudo systemctl daemon-reload                  # Reload systemd to apply the removal.
```