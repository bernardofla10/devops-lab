# Nginx Debugging Checklist

## 1. Check if Nginx Is Running

```bash
systemctl status nginx
```

Look for:

- `active (running)`
- `failed`
- Recent error messages

---

## 2. Test Configuration Syntax

```bash
sudo nginx -t
```

> If this command fails, **do not reload or restart Nginx** until the configuration errors are fixed.

---

## 3. Check systemd Logs

```bash
journalctl -u nginx -n 50 --no-pager
```

---

## 4. Check Nginx Error Logs

```bash
sudo tail -n 50 /var/log/nginx/error.log
```

---

## 5. Check Access Logs

```bash
sudo tail -n 50 /var/log/nginx/access.log
```

---

## 6. Check Listening Ports

```bash
sudo ss -tulpn | grep nginx
sudo lsof -i :80
sudo lsof -i :8080
```

---

## 7. Check Enabled Sites

```bash
ls -la /etc/nginx/sites-available
ls -la /etc/nginx/sites-enabled
```

---

## 8. Check the Web Root

```bash
ls -la /var/www/html
ls -la /var/www/devops-lab
```

---

## 9. Check File Permissions

```bash
namei -l /var/www/devops-lab/index.html
ls -la /var/www/devops-lab
```

---

## 10. Reload Safely

```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## Common Problems

- Nginx service is stopped.
- Wrong port configuration.
- Firewall or security group blocking traffic.
- Invalid configuration syntax.
- Missing semicolon (`;`).
- Site configuration exists but is not enabled.
- Wrong document root (`root`) path.
- Missing `index.html`.
- File or directory permission issues.
- Another process is already using the required port.