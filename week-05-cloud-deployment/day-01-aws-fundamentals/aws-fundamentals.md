# AWS Fundamentals

## Account

An AWS account is the security, billing and resource-isolation boundary.

## Root user

The root user has unrestricted account access.

Use it only for exceptional account-level tasks.

Do not create root access keys.

Enable MFA.

## IAM Identity Center

IAM Identity Center provides centralized human access with temporary
credentials.

CLI authentication:

```bash
aws configure sso \
  --profile devops-lab-readonly

aws sso login \
  --profile devops-lab-readonly
```

## Identity verification

```bash
aws sts get-caller-identity \
  --profile devops-lab-readonly
```

## Region

A Region is a separate geographic area.

Example:

```text
us-east-1
sa-east-1
```

## Availability Zone

An Availability Zone is an isolated location inside a Region.

Example:

```text
us-east-1a
us-east-1b
```

## VPC

A VPC is a logically isolated virtual network.

It contains:

- IP ranges
- subnets
- route tables
- gateways
- security controls

## Subnet

A subnet is an IP-address range inside a VPC.

A subnet belongs to one Availability Zone.

## Route table

A route table determines where network traffic is directed.

## Internet Gateway

An Internet Gateway connects a VPC to the internet when routing and
public addressing are also configured.

## Security Group

A Security Group is a stateful virtual firewall attached to resources
such as EC2 instances.

It controls:

- inbound traffic
- outbound traffic

## EC2

EC2 provides virtual machines.

The application container will run on an EC2 instance.

## EBS

EBS provides block storage for EC2.

Volumes can outlive instances depending on their termination settings.

## ECR

ECR stores Docker and OCI container images.

## CloudWatch

CloudWatch provides:

- metrics
- logs
- dashboards
- alarms

## IAM rule

```text
human user
  temporary credentials through federation

AWS workload
  temporary credentials through IAM role

avoid
  long-lived access keys
```