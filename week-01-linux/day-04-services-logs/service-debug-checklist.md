# Linux Service Debugging Checklist

When a Linux service fails, follow this sequence.

## 1. Check Service Status

```bash
systemctl status service-name
```

Look for:

- `active (running)`
- `failed`
- Exit code
- Recent error messages

---

## 2. Check Recent Logs

```bash
journalctl -u service-name -n 50 --no-pager
```

Look for:

- Permission errors
- Missing files
- Wrong paths
- Missing environment variables
- Port already in use
- Dependency failures

---

## 3. Check the Service File

```bash
sudo systemctl cat service-name
```

Verify:

- `ExecStart`
- `User`
- `WorkingDirectory`
- `Restart`
- Environment variables

---

## 4. Check File Permissions

```bash
ls -la /path/to/executable
```

If needed:

```bash
chmod +x /path/to/executable
```

---

## 5. Reload systemd After Changes

```bash
sudo systemctl daemon-reload
```

---

## 6. Restart the Service

```bash
sudo systemctl restart service-name
```

---

## 7. Follow Logs in Real Time

```bash
journalctl -u service-name -f
```

---

## Common Causes

- Wrong `ExecStart` path
- Missing execute permission
- Wrong `User`
- Wrong `WorkingDirectory`
- Missing environment variable
- Port already in use
- Configuration syntax error
- Dependency not started