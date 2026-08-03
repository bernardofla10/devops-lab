#!/usr/bin/env bash

set -euxo pipefail

dnf install -y nginx

systemctl enable amazon-ssm-agent || true
systemctl start amazon-ssm-agent || true

TOKEN="$(
  curl \
    --fail \
    --silent \
    --show-error \
    --request PUT \
    "http://169.254.169.254/latest/api/token" \
    --header \
    "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
    || true
)"

INSTANCE_ID="unknown"
AVAILABILITY_ZONE="unknown"
LOCAL_IPV4="unknown"

if [ -n "$TOKEN" ]; then
  INSTANCE_ID="$(
    curl \
      --fail \
      --silent \
      --show-error \
      --header \
      "X-aws-ec2-metadata-token: $TOKEN" \
      "http://169.254.169.254/latest/meta-data/instance-id" \
      || echo unknown
  )"

  AVAILABILITY_ZONE="$(
    curl \
      --fail \
      --silent \
      --show-error \
      --header \
      "X-aws-ec2-metadata-token: $TOKEN" \
      "http://169.254.169.254/latest/meta-data/placement/availability-zone" \
      || echo unknown
  )"

  LOCAL_IPV4="$(
    curl \
      --fail \
      --silent \
      --show-error \
      --header \
      "X-aws-ec2-metadata-token: $TOKEN" \
      "http://169.254.169.254/latest/meta-data/local-ipv4" \
      || echo unknown
  )"
fi

cat > /usr/share/nginx/html/index.html <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0"
  >
  <title>DevOps Lab EC2</title>
</head>
<body>
  <h1>DevOps Lab EC2</h1>

  <p>The first AWS EC2 lab is running.</p>

  <dl>
    <dt>Instance ID</dt>
    <dd>${INSTANCE_ID}</dd>

    <dt>Availability Zone</dt>
    <dd>${AVAILABILITY_ZONE}</dd>

    <dt>Private IPv4</dt>
    <dd>${LOCAL_IPV4}</dd>
  </dl>
</body>
</html>
HTML

systemctl enable nginx
systemctl restart nginx

cat > /etc/motd <<MOTD
DevOps Lab EC2

Instance ID: ${INSTANCE_ID}
Availability Zone: ${AVAILABILITY_ZONE}
Private IPv4: ${LOCAL_IPV4}

Useful commands:
  sudo systemctl status nginx
  sudo systemctl status amazon-ssm-agent
  sudo tail -n 100 /var/log/cloud-init-output.log
MOTD