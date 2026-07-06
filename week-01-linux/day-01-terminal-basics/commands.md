# Day 01 - Linux Terminal Commands

## System Information

```bash
pwd                 # Print the current working directory.
ls                  # List files and directories.
ls -la              # List all files, including hidden ones, with detailed information.
whoami              # Display the current logged-in user.
hostname            # Show the system hostname.
date                # Display the current date and time.
uname -a            # Show detailed system and kernel information.
cat /etc/os-release # Display Linux distribution information.
echo $SHELL         # Show the current shell.
echo $PATH          # Display the PATH environment variable.
```

## File and Directory Operations

```bash
mkdir test-dir                      # Create a new directory.
cd test-dir                         # Change to the specified directory.
touch file1.txt file2.txt           # Create empty files.
echo "hello devops" > file1.txt     # Write text to a file (overwrite).
cat file1.txt                       # Display the file contents.
cp file1.txt copy.txt               # Copy a file.
mv copy.txt renamed.txt             # Rename or move a file.
ls -la                              # List directory contents with details.
cd ..                               # Move to the parent directory.
rm -r test-dir                      # Remove a directory and its contents recursively.
```

## Searching Logs

```bash
mkdir logs                                                  # Create a logs directory.
echo "INFO application started" > logs/app.log              # Create a log file with an INFO entry.
echo "ERROR database connection failed" >> logs/app.log     # Append an ERROR entry to the log.
echo "INFO application stopped" >> logs/app.log             # Append another INFO entry.

cat logs/app.log              # Display the log file contents.
grep ERROR logs/app.log       # Search for lines containing "ERROR".
find . -name "*.log"          # Find all .log files recursively.
```

## Processes

```bash
ps aux | head    # Show the first processes running on the system.
top              # Display real-time system processes and resource usage.
```

## Network Checks

```bash
curl https://example.com      # Fetch the contents of a web page.
curl -I https://example.com   # Retrieve only the HTTP response headers.
ping -c 4 google.com          # Send four ICMP packets to test network connectivity.
```
