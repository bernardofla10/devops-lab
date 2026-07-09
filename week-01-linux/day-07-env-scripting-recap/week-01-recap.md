# Week 01 Recap - Linux Operations

## Main Goal

Build practical Linux foundations for DevOps work.

## What I Practiced

### Day 01 - Terminal Basics

- Navigation
- File creation
- Searching with `grep` and `find`
- Basic process inspection
- First Bash script

### Day 02 - Permissions, Users and Groups

- `chmod`
- `chown`
- `sudo`
- Users
- Groups
- Executable scripts
- Secure file permissions

### Day 03 - Processes and Resources

- `ps`
- `top`
- `htop`
- `kill`
- `jobs`
- `fg`
- `bg`
- `free`
- `df`
- `du`
- `uptime`

### Day 04 - Services and Logs

- `systemctl`
- `journalctl`
- Custom systemd service
- Service debugging checklist

### Day 05 - Nginx

- Install Nginx
- Manage the Nginx service
- Configure a custom site
- Create a health endpoint
- Read access and error logs
- Debug configuration with `nginx -t`

### Day 06 - SSH and SCP

- Create an SSH key pair
- Configure local SSH access
- Use `authorized_keys`
- Use `known_hosts`
- Copy files with `scp`
- Debug SSH with `ssh -v`

### Day 07 - Environment Variables and Scripting

- Environment variables
- `.env` and `.env.example`
- Shell scripting safety
- Linux operations report script
- Nginx operations check script

---

## Most Important Commands

```bash
ls -la
chmod
chown
ps aux
top
htop
kill
systemctl status
journalctl -u
nginx -t
curl
ssh
scp
export
source
df -h
free -h
ss -tulpn
```

---

## DevOps Lessons Learned

- Linux is the foundation of servers, containers, and cloud workloads.
- Logs are essential for debugging applications and services.
- Services should be inspected with `systemctl` and `journalctl`.
- Incorrect permissions can break scripts, services, and SSH access.
- Health checks provide a simple way to verify that a service is running.
- SSH is the standard tool for remote server administration.
- Environment variables separate configuration from application code.
- Automation scripts reduce repetitive manual work and troubleshooting time.

---

## Ready for Week 02

The next step is **Docker**.

### Goals for Week 02

- Images
- Containers
- Dockerfiles
- Port mapping
- Volumes
- Environment variables in containers
- Container logs
- Basic container networking