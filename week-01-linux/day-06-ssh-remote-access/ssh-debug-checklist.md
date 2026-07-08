# SSH Debugging Checklist

## 1. Test basic connection

```bash
ssh host
```

If it fails, run:

```bash
ssh -v host
```

## 2. Check SSH service

On the server:

```bash
systemctl status ssh
journalctl -u ssh -n 50 --no-pager
```

## 3. Check if SSH is listening

```bash
sudo ss -tulpn | grep :22
```

## 4. Check username

```bash
whoami
id
```

Make sure you are connecting with the correct remote user:

```bash
ssh user@host
```

## 5. Check key permissions

```bash
ls -la ~/.ssh
```

Recommended permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/private_key
chmod 644 ~/.ssh/private_key.pub
```

## 6. Check authorized keys

On the server:

```bash
cat ~/.ssh/authorized_keys
```

The public key must be there.

## 7. Check SSH config

```bash
cat ~/.ssh/config
```

Check:

- `Host`
- `HostName`
- `User`
- `IdentityFile`
- `Port`

## 8. Check server config

```bash
sudo sshd -T | grep -E "passwordauthentication|pubkeyauthentication|permitrootlogin|authorizedkeysfile"
```

## 9. Common errors

### Permission denied

Check:

- wrong user
- wrong key
- public key missing from `authorized_keys`
- permissions too open

### Connection refused

Check:

- SSH service stopped
- wrong port
- server not listening

### Connection timed out

Check:

- firewall
- cloud security group
- network
- wrong IP

### Host key verification failed

Check:

```bash
cat ~/.ssh/known_hosts
```

If this happens after rebuilding a server, remove the old host key carefully:

```bash
ssh-keygen -R host
```

## 10. Never commit secrets

Never commit:

- private SSH keys
- `.pem` files
- cloud credentials
- `.env` files
- tokens