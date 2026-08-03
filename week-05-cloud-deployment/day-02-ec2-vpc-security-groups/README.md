# Day 02 - EC2, VPC and Security Groups

This lab provisions a small AWS network and an Amazon EC2 instance.

## Resources

- custom VPC
- public subnet
- Internet Gateway
- public route table
- Security Group
- EC2 Amazon Linux 2023
- encrypted gp3 EBS volume
- IAM role and instance profile
- AWS Systems Manager Session Manager
- Nginx

## Security decisions

- no inbound SSH
- no EC2 key pair
- Session Manager for administration
- HTTP restricted to the operator's public IP
- IMDSv2 required
- encrypted EBS
- root volume deleted on termination
- temporary SSO credentials
- consistent resource tags

## Prepare configuration

```bash
cp \
  config/lab.env.example \
  config/lab.env
```

Update:

```text
HTTP_ALLOWED_CIDR
AWS_PROFILE
AWS_REGION
```

## Validate prerequisites

```bash
./scripts/check-prerequisites.sh
```

## Create the EC2 role

```bash
./scripts/create-instance-role.sh
```

## Create the network

```bash
./scripts/create-network.sh
```

## Launch the instance

```bash
./scripts/launch-instance.sh
```

## Verify the instance

```bash
./scripts/verify-instance.sh
```

## Connect through Session Manager

```bash
./scripts/connect-session.sh
```

## Generate inventory

```bash
./scripts/inventory.sh
```

## Stop after the study session

```bash
./scripts/instance-lifecycle.sh stop
```

## Start again

```bash
./scripts/instance-lifecycle.sh start
```

## Permanently remove the lab

```bash
./scripts/cleanup.sh --confirm
```

## Local generated files

```text
config/lab.env
state/resources.env
reports/
```

These files are ignored by Git.