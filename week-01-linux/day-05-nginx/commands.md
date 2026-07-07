# Day 05 - Nginx Local Web Server

## Install Nginx

```bash
sudo apt update              # Update the package index.
sudo apt install nginx -y    # Install Nginx.
nginx -v                     # Display the installed Nginx version.
```

## Manage Nginx Service

```bash
systemctl status nginx         # Show the Nginx service status.
sudo systemctl start nginx     # Start the Nginx service.
sudo systemctl stop nginx      # Stop the Nginx service.
sudo systemctl restart nginx   # Restart the Nginx service.
sudo systemctl reload nginx    # Reload the configuration without stopping the service.
```

## Test Nginx

```bash
curl http://localhost      # Fetch the default Nginx web page.
curl -I http://localhost   # Retrieve only the HTTP response headers.
```

## Default Web Root

```bash
ls -la /var/www/html                                                    # List the default web root contents.
cat /var/www/html/index.nginx-debian.html | head                        # Display the first lines of the default page.
sudo cp /var/www/html/index.nginx-debian.html /var/www/html/index.nginx-debian.html.bak  # Create a backup of the default page.
sudo nano /var/www/html/index.html                                      # Create or edit the custom homepage.
```

## Logs

```bash
sudo tail -n 20 /var/log/nginx/access.log      # Show the last 20 access log entries.
sudo tail -n 20 /var/log/nginx/error.log       # Show the last 20 error log entries.
sudo tail -f /var/log/nginx/access.log         # Follow the access log in real time.
journalctl -u nginx -n 50 --no-pager           # Display the last 50 Nginx service log entries.
```

## Nginx Configuration Files

```bash
ls -la /etc/nginx                          # List the main Nginx configuration directory.
ls -la /etc/nginx/sites-available          # List available virtual host configurations.
ls -la /etc/nginx/sites-enabled            # List enabled virtual host configurations.
cat /etc/nginx/sites-available/default     # Display the default site configuration.
```

## Test Configuration

```bash
sudo nginx -t    # Validate the Nginx configuration syntax.
```

## Custom Site Setup

```bash
sudo mkdir -p /var/www/devops-lab                                                   # Create the custom website directory.
sudo cp ~/devops-lab/week-01-linux/day-05-nginx/index.html /var/www/devops-lab/index.html  # Copy the website files.

sudo chown -R www-data:www-data /var/www/devops-lab    # Set the web server as the owner.
sudo chmod -R 755 /var/www/devops-lab                  # Set appropriate directory permissions.

sudo cp ~/devops-lab/week-01-linux/day-05-nginx/nginx-lab.conf /etc/nginx/sites-available/nginx-lab  # Install the site configuration.
sudo ln -s /etc/nginx/sites-available/nginx-lab /etc/nginx/sites-enabled/nginx-lab                    # Enable the site.

sudo nginx -t                  # Validate the configuration.
sudo systemctl reload nginx    # Reload Nginx to apply the changes.
```

## Test Custom Site

```bash
curl http://localhost:8080         # Request the custom website.
curl http://localhost:8080/health  # Test the health check endpoint.
curl -I http://localhost:8080      # Retrieve only the HTTP response headers.
```

## Check Open Ports

```bash
sudo ss -tulpn | grep nginx    # Display listening ports used by Nginx.
sudo lsof -i :8080             # Show the process using port 8080.
```

## Health Check Script

```bash
chmod +x health-check.sh                    # Make the script executable.
./health-check.sh                           # Run the health check using the default URL.
./health-check.sh http://localhost:8080/wrong  # Test the script against an invalid endpoint.
```

## Cleanup (Optional)

```bash
sudo rm /etc/nginx/sites-enabled/nginx-lab      # Disable the custom site.
sudo rm /etc/nginx/sites-available/nginx-lab    # Remove the site configuration.
sudo rm -rf /var/www/devops-lab                 # Delete the custom website files.
sudo nginx -t                                   # Validate the remaining configuration.
sudo systemctl reload nginx                     # Reload Nginx after cleanup.
```