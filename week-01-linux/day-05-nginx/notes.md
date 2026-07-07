# Day 05 - Nginx Local Web Server

## Goal

Install, configure, and debug a local Nginx web server.

## Why This Matters for DevOps

Nginx is commonly used as:

- A web server
- A reverse proxy
- A load balancer
- A TLS termination layer
- A gateway in front of backend services

Understanding Nginx helps with deployments, debugging, production operations, and infrastructure work.

## Key Concepts

Nginx runs as a Linux service managed by **systemd**.

The default web root on Ubuntu is usually:

```bash
/var/www/html
```

### Important Paths

```text
/etc/nginx/nginx.conf
/etc/nginx/sites-available/
/etc/nginx/sites-enabled/
/var/log/nginx/access.log
/var/log/nginx/error.log
/var/www/html/
```

## Commands Practiced

```bash
sudo apt install nginx
systemctl status nginx
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
systemctl reload nginx
journalctl -u nginx
tail -f
nginx -t
curl
ss
lsof
```

## Important Lessons

- `systemctl status nginx` shows whether Nginx is running.
- `journalctl -u nginx` displays the Nginx service logs.
- `/var/log/nginx/access.log` contains HTTP access requests.
- `/var/log/nginx/error.log` contains Nginx error messages.
- `sudo nginx -t` validates the configuration before a reload or restart.
- `reload` is usually safer than `restart` when applying configuration changes.
- `sites-available` stores all available site configurations.
- `sites-enabled` contains symbolic links to the enabled sites.
- A missing semicolon (`;`) can break the Nginx configuration.
- `ss -tulpn` helps identify which process is listening on a port.

## Debugging Flow

When Nginx does not work, run the following commands:

```bash
systemctl status nginx
sudo nginx -t
journalctl -u nginx -n 50 --no-pager
sudo tail -n 50 /var/log/nginx/error.log
sudo ss -tulpn | grep nginx
```

Then verify:

- Is Nginx running?
- Is the configuration syntax valid?
- Is the correct port being used?
- Is the site enabled?
- Is the root directory correct?
- Does the requested file exist?
- Are the file permissions correct?
- Is another process already using the port?

## Next Step

Study SSH and remote access basics.