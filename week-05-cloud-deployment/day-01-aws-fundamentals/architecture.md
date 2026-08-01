# AWS Deployment Architecture

## Week 05 target

```text
Developer
  |
  v
GitHub repository
  |
  v
GitHub Actions
  |
  | OIDC temporary credentials
  v
AWS IAM role
  |
  +----------------------+
  |                      |
  v                      v
Amazon ECR           Amazon EC2
  |                      |
  | Docker image         | docker pull
  +--------------------->|
                         |
                         v
                  Docker container
                         |
                         v
                    CloudWatch
```

## Day 01 scope

Day 01 prepares:

- AWS account security
- MFA
- IAM Identity Center
- AWS CLI
- SSO authentication
- region selection
- read-only inventory
- cost alerts

Day 01 does not provision:

- EC2 instances
- ECR repositories
- load balancers
- NAT gateways
- databases

## Future traffic flow

```text
Internet
  |
  v
Security Group
  |
  v
EC2 host port 80
  |
  v
Nginx reverse proxy
  |
  v
Application container port 3000
```

## Future image flow

```text
GitHub Actions
  |
  v
Build and scan image
  |
  v
Amazon ECR
  |
  v
EC2 docker pull
  |
  v
Container deployment
```