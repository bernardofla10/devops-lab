# Day 01 - AWS Fundamentals Commands

## Create branch

```bash
git checkout main
git pull

git checkout -b \
  week-05/day-01-aws-fundamentals
```

## Install AWS CLI prerequisites

```bash
sudo apt update

sudo apt install -y \
  curl \
  unzip \
  jq
```

## Install AWS CLI v2

```bash
curl \
  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o /tmp/awscliv2.zip

unzip -q \
  /tmp/awscliv2.zip \
  -d /tmp

sudo /tmp/aws/install --update

aws --version
```

## Configure SSO

```bash
aws configure sso \
  --profile devops-lab-readonly
```

## Log in

```bash
aws sso login \
  --profile devops-lab-readonly
```

## Verify identity

```bash
aws sts get-caller-identity \
  --profile devops-lab-readonly
```

## Prepare lab configuration

```bash
cp \
  config/lab.env.example \
  config/lab.env
```

## Run lab scripts

```bash
chmod +x scripts/*.sh

./scripts/check-prerequisites.sh
./scripts/aws-login.sh
./scripts/aws-identity.sh
./scripts/aws-safety-check.sh
./scripts/aws-inventory.sh
./scripts/ci-local.sh
```

## Inspect inventory

```bash
jq '.AvailabilityZones' \
  reports/inventory/availability-zones.json

jq '.Vpcs' \
  reports/inventory/vpcs.json

jq '.SecurityGroups' \
  reports/inventory/security-groups.json
```

## Push branch

```bash
git push \
  -u origin \
  week-05/day-01-aws-fundamentals
```

## Create pull request

```bash
gh pr create \
  --base main \
  --head week-05/day-01-aws-fundamentals \
  --title "Week 05 Day 01 - AWS Fundamentals" \
  --body "Adds secure AWS account preparation, CLI SSO authentication, read-only inventory and cost-safety documentation."
```