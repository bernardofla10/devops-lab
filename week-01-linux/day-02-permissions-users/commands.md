# Day 02 - Linux Permissions, Users and Groups

## Inspecting Permissions

```bash
ls -la    # List files with detailed permissions, ownership, and metadata.
```

## Creating Test Files

```bash
mkdir permission-test                              # Create a new directory.
cd permission-test                                 # Change to the new directory.

touch app.log config.env deploy.sh                 # Create empty files.

echo "APP_ENV=development" > config.env            # Write an environment variable to a file.
echo "INFO application started" > app.log          # Write a log entry to a file.
echo 'echo "Deploy script running..."' > deploy.sh # Create a simple shell script.
```

## Executing a Script

```bash
./deploy.sh           # Try to execute the script.
chmod +x deploy.sh    # Add execute permission to the script.
./deploy.sh           # Execute the script.
```

## Symbolic chmod

```bash
chmod u+x deploy.sh     # Add execute permission for the owner.
chmod g-w config.env    # Remove write permission from the group.
chmod o-r config.env    # Remove read permission from others.
chmod u+rwx deploy.sh   # Give the owner full permissions.
chmod g+rx deploy.sh    # Give the group read and execute permissions.
chmod o-rwx deploy.sh   # Remove all permissions from others.
```

## Numeric chmod

```bash
chmod 644 app.log       # Set permissions to rw-r--r--.
chmod 600 config.env    # Set permissions to rw-------.
chmod 755 deploy.sh     # Set permissions to rwxr-xr-x.
```

## User and Group Information

```bash
whoami    # Display the current logged-in user.
id         # Show user and group IDs.
groups     # List the groups the current user belongs to.
```

## Changing Ownership

```bash
sudo chown devops-test:devops-test secret.txt   # Change the file owner and group.
sudo chown $(whoami):$(whoami) secret.txt       # Change ownership to the current user.
```

## Sudo

```bash
whoami         # Display the current user.
sudo whoami    # Run the command as the root user.
```

## Useful Permission Patterns

| Permission | Use Case |
|------------|----------|
| **644** | Regular files (owner can read/write, others can only read). |
| **755** | Executable scripts and programs. |
| **600** | Secrets, private keys, and `.env` files. |
| **700** | Private directories or scripts accessible only by the owner. |