# Day 02 - EC2, VPC and Security Groups

## Goal

Provision and operate the first secure EC2 environment.

## Network

The lab created:

- one custom VPC
- one public subnet
- one Internet Gateway
- one public route table
- one Security Group

## Public subnet

The subnet is public because its route table contains:

```text
0.0.0.0/0 -> Internet Gateway
```

The EC2 instance also receives a public IPv4 address.

## Security Group

Inbound traffic allows only:

```text
TCP 80 from the operator public IP /32
```

Port 22 is not exposed.

## Administrative access

Session Manager replaces public SSH.

It uses:

- temporary SSO credentials for the operator
- an EC2 instance profile
- AmazonSSMManagedInstanceCore
- SSM Agent
- outbound HTTPS connectivity

## EC2

The instance uses:

- Amazon Linux 2023
- `t3.micro`
- encrypted `gp3` root volume
- Amazon SSM public AMI parameter
- IMDSv2
- user data
- Nginx

## Instance metadata

IMDSv2 requires a token.

Requests without a token fail.

## User data

The bootstrap script:

1. installs Nginx
2. starts SSM Agent
3. reads metadata through IMDSv2
4. creates an HTML page
5. starts Nginx

## Stop and start

Stopping an instance:

- stops compute billing
- preserves EBS
- preserves the private IPv4
- can change the public IPv4
- loses RAM contents

## Termination

Termination permanently removes the instance.

The root EBS volume is configured with:

```text
DeleteOnTermination=true
```

## Important lessons

- A public subnet needs routing and public addressing.
- An Internet Gateway alone does not make an instance public.
- A Security Group is stateful.
- Public SSH is not required for administration.
- EC2 workloads should use IAM roles instead of access keys.
- The latest AMI can be resolved dynamically.
- IMDSv2 should be required.
- Infrastructure resources need consistent tags.
- Stop and terminate are different operations.
- Cleanup automation is part of infrastructure engineering.

## Next step

Create an Amazon ECR repository and publish a validated Docker image.