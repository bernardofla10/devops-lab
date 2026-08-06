# Day 02 - EC2, VPC and Security Group Commands

## Create branch

```bash
git checkout main
git pull

git checkout -b \
  week-05/day-02-ec2-vpc-security-groups
```

## Configure AWS SSO

```bash
aws configure sso \
  --profile devops-lab-provisioner

aws sso login \
  --profile devops-lab-provisioner
```

## Install Session Manager Plugin

```bash
curl \
  "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
  -o /tmp/session-manager-plugin.deb

sudo dpkg \
  -i /tmp/session-manager-plugin.deb

session-manager-plugin
```

## Detect public IP

```bash
curl \
  -fsS \
  https://checkip.amazonaws.com
```

## Prepare local configuration

```bash
cp \
  config/lab.env.example \
  config/lab.env

nano config/lab.env
```

## Validate

```bash
chmod +x scripts/*.sh
chmod +x user-data/bootstrap.sh

./scripts/ci-local.sh
./scripts/check-prerequisites.sh
```

## Provision

```bash
./scripts/create-instance-role.sh
./scripts/create-network.sh
./scripts/launch-instance.sh
```

## Verify

```bash
./scripts/verify-instance.sh
./scripts/inventory.sh
```

## Connect

```bash
./scripts/connect-session.sh
```

## Lifecycle

```bash
./scripts/instance-lifecycle.sh status
./scripts/instance-lifecycle.sh stop
./scripts/instance-lifecycle.sh start
```

## Cleanup

```bash
./scripts/cleanup.sh --confirm
```

## Push branch

```bash
git push \
  -u origin \
  week-05/day-02-ec2-vpc-security-groups
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-05/day-02-ec2-vpc-security-groups \
  --title "Week 05 Day 02 - EC2 and VPC" \
  --body "Adds a secure EC2 lab with a custom VPC, Session Manager access, restricted Security Group and cleanup automation."
```