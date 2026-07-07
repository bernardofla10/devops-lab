# Day 04 - Linux Services and Logs

## Goal

Understand how Linux services are managed with systemd and how to inspect logs with journalctl.

## Why this matters for DevOps

In production, applications usually run as services.

DevOps engineers need to answer:

- Is the service running?
- Did the service fail?
- Why did it fail?
- When did it restart?
- Which user is running the service?
- Where are the logs?

## Key concepts

A process is a running program.

A service is a process managed by the operating system.

systemd is a service manager used by many Linux distributions.

journalctl is used to read logs collected by systemd.

## Commands practiced

- `systemctl status`
- `systemctl start`
- `systemctl stop`
- `systemctl restart`
- `systemctl enable`
- `systemctl disable`
- `systemctl is-enabled`
- `journalctl -u`
- `journalctl -f`
- `journalctl -n`

## Important lessons

- `systemctl status service-name` shows whether a service is running or failed.
- `journalctl -u service-name` shows logs for a specific service.
- `journalctl -f` follows logs in real time.
- `systemctl daemon-reload` is needed after changing a service file.
- `Restart=always` makes systemd restart the service if it crashes.
- A wrong `ExecStart` path causes the service to fail.
- Services should run as a regular user when possible, not always as root.

## Debugging flow

When a service fails, use:

```bash
systemctl status service-name
journalctl -u service-name -n 50 --no-pager
```
Then check:
- Is the ExecStart path correct?
- Does the file have execute permission?
- Is the User correct?
- Is the WorkingDirectory correct?
- Did I run sudo systemctl daemon-reload after editing the service file?
- Are environment variables missing?

## Next step

Install and manage a real service: Nginx.