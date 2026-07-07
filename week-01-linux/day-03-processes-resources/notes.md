# Day 03 - Linux Processes and System Resources

## Goal

Understand how Linux processes work and how to inspect basic system resources.

## Why this matters for DevOps

DevOps work often involves debugging running systems.

Common questions:

- Is the application running?
- Which process is using too much CPU?
- Which process is using too much memory?
- Is the disk full?
- How long has the server been running?
- How do I stop a broken process safely?

## Key concepts

A process is a running program.

Each process has a PID (Process ID).

A process can run in:

- foreground
- background

Processes can be stopped, suspended, or killed.

## Commands Practiced

| Command | Description |
|---------|-------------|
| `ps` | Display information about running processes. |
| `top` | Monitor processes and system resource usage in real time. |
| `htop` | Interactive process viewer with an improved interface. |
| `kill` | Send a signal to terminate or control a process. |
| `jobs` | List background jobs in the current shell. |
| `fg` | Bring a background job to the foreground. |
| `bg` | Resume a suspended job in the background. |
| `free` | Display memory usage. |
| `df` | Show disk space usage by filesystem. |
| `du` | Display disk usage of files and directories. |
| `uptime` | Show system uptime and load average. |

## Important Lessons

- `ps aux` — List all running processes with detailed information.
- `top` — Monitor processes and system resources in real time.
- `htop` — Interactive process monitor with an improved interface.
- `kill PID` — Request a process to terminate gracefully.
- `kill -9 PID` — Forcefully terminate a process (use as a last resort).
- `free -h` — Display memory usage in a human-readable format.
- `df -h` — Show disk usage by filesystem in a human-readable format.
- `du -sh` — Display the total size of a directory in a human-readable format.
- `uptime` — Show how long the system has been running and its load average.

## DevOps Debugging Examples

If an application is slow, I can check CPU and memory usage with:

```bash
top                                # Monitor processes and resources in real time.
htop                               # Open the interactive process viewer.
ps aux --sort=-%cpu | head         # Show the processes using the most CPU.
ps aux --sort=-%mem | head         # Show the processes using the most memory.
```

If a server is failing, I can check whether the disk is full with:

```bash
df -h      # Display disk usage for all mounted filesystems.
du -sh *   # Show the size of each file and directory in the current folder.
```

If a script is stuck, I can find it and stop it with:

```bash
ps aux | grep '[s]cript-name'    # Search for the script process.
kill PID                         # Gracefully terminate the process.
```

## Next Step

Study Linux services with `systemctl` and system logs with `journalctl`.