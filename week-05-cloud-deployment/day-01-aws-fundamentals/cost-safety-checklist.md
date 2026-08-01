# AWS Cost and Safety Checklist

## Account security

- [ ] Root account MFA is enabled
- [ ] No root access keys exist
- [ ] Daily access uses IAM Identity Center
- [ ] The CLI identity is not root
- [ ] Recovery information is stored securely
- [ ] No credentials are committed to Git

## Billing

- [ ] Billing access was reviewed
- [ ] Monthly budget was created
- [ ] Actual-spend alert was configured
- [ ] Forecasted-spend alert was configured
- [ ] Alert e-mail was confirmed
- [ ] Free-plan or credit eligibility was reviewed

## Resource safety

Before creating a resource, answer:

- [ ] Does it have an hourly cost?
- [ ] Does it have a data-processing cost?
- [ ] Does it create persistent storage?
- [ ] Does it create a public IPv4 address?
- [ ] Does stopping it stop every charge?
- [ ] Does deleting it remove associated storage?
- [ ] How will it be destroyed after the lab?

## High-risk lab resources

Pay extra attention to:

- NAT Gateways
- load balancers
- managed databases
- public IPv4 addresses
- Elastic IP addresses
- EBS volumes
- snapshots
- Kubernetes clusters
- data transfer

## End-of-day check

```bash
./scripts/aws-inventory.sh
```

Review:

- EC2 instances
- EBS volumes
- ECR repositories
- S3 buckets
- CloudWatch log groups
- networking resources

## Rule

```text
create intentionally
tag consistently
inspect after use
delete after the lab
confirm billing
```