# EC2 and VPC Lab Architecture

## Network

```text
VPC
10.50.0.0/16
│
├── Internet Gateway
│
├── Public Route Table
│     └── 0.0.0.0/0 -> Internet Gateway
│
└── Public Subnet
      10.50.1.0/24
      │
      └── Amazon EC2
            ├── Private IPv4
            ├── Temporary public IPv4
            ├── Encrypted gp3 root volume
            ├── IAM instance profile
            ├── SSM Agent
            └── Nginx
```

## Inbound traffic

```text
operator public IP /32
        |
        | TCP 80
        v
Security Group
        |
        v
Nginx
```

The Security Group does not allow inbound SSH.

## Administrative access

```text
Operator
  |
  | AWS CLI and temporary SSO credentials
  v
AWS Systems Manager Session Manager
  |
  | HTTPS outbound session channel
  v
SSM Agent on EC2
```

## IAM

```text
DevOpsLabEc2Role
  |
  └── AmazonSSMManagedInstanceCore

DevOpsLabEc2Profile
  |
  └── DevOpsLabEc2Role

EC2
  |
  └── DevOpsLabEc2Profile
```

## Future deployment flow

```text
Amazon ECR
  |
  | docker pull
  v
EC2
  |
  v
Application container
```