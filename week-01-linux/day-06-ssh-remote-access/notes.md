# Day 06 - SSH, SCP and Remote Access

## Goal

Understand SSH and SCP basics for remote server access and file transfer.

## Why this matters for DevOps

DevOps engineers often need to access servers to:

- inspect logs
- restart services
- check system resources
- copy configuration files
- run deployment commands
- debug production issues
- configure web servers
- manage cloud instances

## Key concepts

SSH means Secure Shell.

It allows secure remote access to another machine.

SCP means Secure Copy.

It copies files between machines using SSH.

## SSH key pair

An SSH key pair has two files:

- private key
- public key

The private key stays on my machine.

The public key goes into the remote server in:

```bash
~/.ssh/authorized_keys
```

## Important SSH files

```bash
~/.ssh/config
~/.ssh/authorized_keys
~/.ssh/known_hosts
~/.ssh/devops_lab_ed25519
~/.ssh/devops_lab_ed25519.pub
```

## Important permissions

```bash
~/.ssh                  -> 700
private key             -> 600
public key              -> 644
authorized_keys         -> 600
config                  -> 600
```

## Commands practiced

- `ssh`
- `scp`
- `ssh-keygen`
- `chmod`
- `ss`
- `journalctl -u ssh`
- `sshd -T`

## Important lessons

- SSH can be used interactively or to run one remote command.
- SCP copies files over SSH.
- The private key must never be committed to GitHub.
- `authorized_keys` stores allowed public keys.
- `known_hosts` stores known server identities.
- `~/.ssh/config` creates useful aliases.
- `ssh -v` helps debug connection problems.
- Incorrect permissions can break SSH authentication.

## Debugging flow

When SSH does not work:

```bash
ssh -v host
systemctl status ssh
journalctl -u ssh -n 50 --no-pager
sudo ss -tulpn | grep :22
ls -la ~/.ssh
```

Then check:

- Is the SSH service running?
- Is the port correct?
- Is the username correct?
- Is the private key correct?
- Is the public key in `authorized_keys`?
- Are permissions correct?
- Is the host blocked by firewall or security group?
- Did the host key change?

## Common errors

### Permission denied

Possible causes:

- wrong username
- wrong private key
- public key not in `authorized_keys`
- wrong file permissions

### Connection refused

Possible causes:

- SSH service is not running
- wrong port
- server is not listening on port 22

### Connection timed out

Possible causes:

- network issue
- firewall
- cloud security group blocking port 22

### Bad permissions

Possible causes:

- private key too open
- `~/.ssh` permissions too open
- `authorized_keys` permissions wrong


## Next step

Review environment variables and shell scripting, then consolidate Week 01 with a Linux operations mini-lab.