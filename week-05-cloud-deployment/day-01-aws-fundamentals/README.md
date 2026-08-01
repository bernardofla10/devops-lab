# Day 01 - Cloud and AWS Fundamentals

This lab prepares a secure AWS foundation before infrastructure
provisioning.

## Goals

- secure the AWS account
- enable root MFA
- use IAM Identity Center
- configure temporary CLI credentials
- understand Regions and Availability Zones
- understand IAM, VPC, EC2, ECR and CloudWatch
- generate a read-only account inventory
- configure cost alerts
- prevent credentials from reaching Git

## Important rule

Do not use root credentials with the AWS CLI.

Do not commit:

- access keys
- secret access keys
- session tokens
- private keys
- local AWS configuration
- generated account inventory

## Prepare local configuration

```bash
cp \
  config/lab.env.example \
  config/lab.env
```

Edit:

```bash
nano config/lab.env
```

## Check prerequisites

```bash
./scripts/check-prerequisites.sh
```

## Authenticate

```bash
./scripts/aws-login.sh
```

## Verify identity

```bash
./scripts/aws-identity.sh
```

## Run safety checks

```bash
./scripts/aws-safety-check.sh
```

## Generate account inventory

```bash
./scripts/aws-inventory.sh
```

## Validate repository files

```bash
./scripts/ci-local.sh
```

## Generated local reports

```text
reports/identity/
reports/inventory/
```

Reports are ignored by Git because they may contain account identifiers
and infrastructure metadata.

## Day 01 boundaries

This lab does not create cloud infrastructure.

The next lab will create:

- an EC2 instance
- an IAM role for EC2
- a Security Group
- controlled SSH or Session Manager access