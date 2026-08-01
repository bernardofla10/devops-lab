# Day 01 - Cloud and AWS Fundamentals

## Goal

Prepare the AWS account and local environment safely before creating
cloud resources.

## Root account

The root identity is reserved for exceptional account-level tasks.

Daily CLI usage must not use root credentials.

## Authentication

The lab uses IAM Identity Center and temporary credentials.

Profile:

```text
devops-lab-readonly
```

## Region

The default lab Region is:

```text
us-east-1
```

The Region must be selected intentionally based on:

- latency
- cost
- compliance
- service availability
- data residency

## Read-only identity

Day 01 uses read-only permissions.

Provisioning permissions will be added separately for the next labs.

## Services introduced

- IAM
- IAM Identity Center
- STS
- VPC
- subnet
- route table
- Internet Gateway
- Security Group
- EC2
- EBS
- ECR
- CloudWatch
- S3

## Cost management

A monthly budget and multiple alerts were configured before
infrastructure creation.

## Local reports

The scripts generate identity and inventory reports.

Those reports are not committed because they may contain:

- AWS account ID
- IAM role ARN
- VPC identifiers
- subnet identifiers
- Security Group identifiers
- resource names

## Important lessons

- Account security comes before infrastructure.
- The root identity must not be used for routine work.
- Temporary credentials are preferable to permanent access keys.
- Every command is executed against a specific profile and Region.
- Regions do not automatically share resources.
- A subnet belongs to one Availability Zone.
- Security Groups control network access to EC2.
- Stopped and terminated resources have different cost implications.
- Persistent resources must be inspected after each lab.
- Cloud inventory is operational evidence.

## Next step

Create the first EC2 instance with a dedicated IAM role, Security Group
and controlled remote access.