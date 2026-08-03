# EC2, VPC and Security Group Fundamentals

## VPC

A VPC is a logically isolated network in AWS.

The lab uses:

```text
10.50.0.0/16
```

## Subnet

A subnet is an IP range inside a VPC.

The lab uses:

```text
10.50.1.0/24
```

A subnet belongs to one Availability Zone.

## Public subnet

A subnet is public when its route table sends internet traffic to an
Internet Gateway.

```text
0.0.0.0/0 -> Internet Gateway
```

An IPv4 instance also needs a public IPv4 address to communicate
through the Internet Gateway.

## Route table

A route table determines the next destination for network traffic.

Local VPC traffic uses the automatically created local route.

Internet traffic uses:

```text
0.0.0.0/0 -> igw-...
```

## Internet Gateway

An Internet Gateway connects the VPC to the public internet.

It does not replace:

- routing
- public addressing
- Security Group rules

All three must be correct.

## Security Group

A Security Group is a stateful firewall.

The lab allows:

```text
TCP 80
source: operator-public-ip/32
```

The lab does not allow:

```text
TCP 22
```

## EC2

EC2 provides virtual machines.

The instance uses:

```text
Amazon Linux 2023
t3.micro
encrypted gp3 EBS
```

## AMI

An AMI defines the operating-system image used to launch an instance.

The lab resolves the latest AL2023 AMI from a public SSM parameter.

## EBS

The root filesystem is stored in an encrypted EBS volume.

```text
DeleteOnTermination=true
```

## Instance profile

An instance profile passes an IAM role to an EC2 instance.

The instance receives temporary credentials from the role.

## Session Manager

Session Manager provides administrative shell access without a public
SSH port or a private SSH key.

Requirements:

- SSM Agent
- instance permissions
- outbound HTTPS connectivity
- operator Session Manager permissions
- Session Manager plugin on the client

## IMDSv2

The Instance Metadata Service exposes instance metadata locally.

This lab requires token-based IMDSv2:

```text
HttpTokens=required
```

## Stop versus terminate

```text
stop
  instance can be started again
  EBS remains
  compute billing stops
  public IPv4 can change

terminate
  instance is permanently deleted
  root EBS is deleted when configured
  instance cannot be started again
```