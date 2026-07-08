# Day 06 - SSH, SCP and Remote Access

## Install SSH Client and Server

```bash
ssh -V                                              # Display the installed SSH client version.

sudo apt update                                     # Update the package index.
sudo apt install openssh-client openssh-server -y   # Install the SSH client and server.
```

## Manage SSH Service

```bash
systemctl status ssh                 # Show the SSH service status.
sudo systemctl start ssh             # Start the SSH service.
sudo systemctl restart ssh           # Restart the SSH service.
journalctl -u ssh -n 50 --no-pager   # Display the last 50 SSH service log entries.
```

## Check SSH Port

```bash
sudo ss -tulpn | grep :22    # Verify that SSH is listening on port 22.
```

## Create SSH Key

```bash
mkdir -p ~/.ssh                                            # Create the SSH configuration directory.
chmod 700 ~/.ssh                                           # Restrict directory access to the owner.

ssh-keygen -t ed25519 -C "devops-lab" -f ~/.ssh/devops_lab_ed25519   # Generate a new Ed25519 SSH key pair.

chmod 600 ~/.ssh/devops_lab_ed25519                        # Secure the private key.
chmod 644 ~/.ssh/devops_lab_ed25519.pub                    # Set permissions for the public key.
```

## Authorize Public Key Locally

```bash
cat ~/.ssh/devops_lab_ed25519.pub >> ~/.ssh/authorized_keys   # Add the public key to the authorized keys list.
chmod 600 ~/.ssh/authorized_keys                              # Secure the authorized keys file.
```

## Connect with SSH

```bash
ssh -i ~/.ssh/devops_lab_ed25519 $(whoami)@localhost                     # Open an interactive SSH session.
ssh -i ~/.ssh/devops_lab_ed25519 $(whoami)@localhost "whoami"            # Execute a remote command to display the current user.
ssh -i ~/.ssh/devops_lab_ed25519 $(whoami)@localhost "hostname && uptime" # Display the remote hostname and uptime.
ssh -i ~/.ssh/devops_lab_ed25519 $(whoami)@localhost "df -h && free -h"   # Display remote disk and memory usage.
```

## SSH Config

```bash
nano ~/.ssh/config                             # Create or edit the SSH client configuration.
chmod 600 ~/.ssh/config                        # Restrict access to the SSH configuration file.
ssh devops-local                               # Connect using the SSH host alias.
ssh devops-local "hostname && uptime"          # Execute a command using the SSH host alias.
```

## SCP

```bash
echo "Hello from local machine" > local-file.txt      # Create a local file.

ssh devops-local "mkdir -p ~/ssh-lab-remote"          # Create a remote directory.

scp local-file.txt devops-local:~/ssh-lab-remote/     # Copy the file to the remote machine.

ssh devops-local "ls -la ~/ssh-lab-remote && cat ~/ssh-lab-remote/local-file.txt"  # Verify the transferred file.

scp devops-local:~/ssh-lab-remote/local-file.txt ./copied-back-file.txt   # Copy the file back to the local machine.

cat copied-back-file.txt                              # Display the copied file contents.

rm local-file.txt copied-back-file.txt                # Remove the test files.
```

## Debug SSH

```bash
ssh -v devops-local      # Enable basic SSH debug output.
ssh -vv devops-local     # Enable verbose SSH debug output.
ssh -vvv devops-local    # Enable maximum SSH debug output.
```

## Check SSH Server Configuration

```bash
sudo sshd -T | grep -E "passwordauthentication|pubkeyauthentication|permitrootlogin|authorizedkeysfile"   # Display key SSH server authentication settings.
```

## Useful Permissions

```bash
chmod 700 ~/.ssh                         # Restrict access to the SSH directory.
chmod 600 ~/.ssh/config                  # Secure the SSH client configuration.
chmod 600 ~/.ssh/authorized_keys         # Secure the authorized keys file.
chmod 600 ~/.ssh/devops_lab_ed25519      # Secure the private SSH key.
chmod 644 ~/.ssh/devops_lab_ed25519.pub  # Set permissions for the public SSH key.
```