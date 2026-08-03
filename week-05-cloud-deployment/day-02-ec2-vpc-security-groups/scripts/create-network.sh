#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

source "$PROJECT_DIRECTORY/scripts/common.sh"

if [ -f "$STATE_FILE" ]; then
  load_state

  if [ -n "${VPC_ID:-}" ]; then
    echo "A VPC is already recorded in the state file:"
    echo "$VPC_ID"
    echo ""
    echo "Inspect it with:"
    echo "./scripts/inventory.sh"
    exit 1
  fi
fi

echo "AWS VPC Provisioning"
echo "===================="
echo ""
echo "VPC CIDR:    $VPC_CIDR"
echo "Subnet CIDR: $PUBLIC_SUBNET_CIDR"
echo "HTTP source: $HTTP_ALLOWED_CIDR"
echo ""

echo "1. Selecting an Availability Zone"

if [ -n "${PUBLIC_SUBNET_AZ:-}" ]; then
  SELECTED_AZ="$PUBLIC_SUBNET_AZ"
else
  SELECTED_AZ="$(
    aws_cli ec2 describe-availability-zones \
      --filters \
        Name=state,Values=available \
      --query \
        'AvailabilityZones[0].ZoneName' \
      --output text
  )"
fi

echo "Availability Zone: $SELECTED_AZ"

save_state \
  PUBLIC_SUBNET_AZ \
  "$SELECTED_AZ"

echo ""
echo "2. Creating VPC"

VPC_ID="$(
  aws_cli ec2 create-vpc \
    --cidr-block "$VPC_CIDR" \
    --query 'Vpc.VpcId' \
    --output text
)"

save_state VPC_ID "$VPC_ID"

tag_ec2_resource \
  "$VPC_ID" \
  "${LAB_NAME}-vpc"

aws_cli ec2 modify-vpc-attribute \
  --vpc-id "$VPC_ID" \
  --enable-dns-support '{"Value":true}'

aws_cli ec2 modify-vpc-attribute \
  --vpc-id "$VPC_ID" \
  --enable-dns-hostnames '{"Value":true}'

echo "VPC: $VPC_ID"

echo ""
echo "3. Creating public subnet"

SUBNET_ID="$(
  aws_cli ec2 create-subnet \
    --vpc-id "$VPC_ID" \
    --cidr-block "$PUBLIC_SUBNET_CIDR" \
    --availability-zone "$SELECTED_AZ" \
    --query 'Subnet.SubnetId' \
    --output text
)"

save_state SUBNET_ID "$SUBNET_ID"

tag_ec2_resource \
  "$SUBNET_ID" \
  "${LAB_NAME}-public-subnet"

aws_cli ec2 modify-subnet-attribute \
  --subnet-id "$SUBNET_ID" \
  --map-public-ip-on-launch

echo "Subnet: $SUBNET_ID"

echo ""
echo "4. Creating Internet Gateway"

INTERNET_GATEWAY_ID="$(
  aws_cli ec2 create-internet-gateway \
    --query 'InternetGateway.InternetGatewayId' \
    --output text
)"

save_state \
  INTERNET_GATEWAY_ID \
  "$INTERNET_GATEWAY_ID"

tag_ec2_resource \
  "$INTERNET_GATEWAY_ID" \
  "${LAB_NAME}-igw"

aws_cli ec2 attach-internet-gateway \
  --internet-gateway-id "$INTERNET_GATEWAY_ID" \
  --vpc-id "$VPC_ID"

echo "Internet Gateway: $INTERNET_GATEWAY_ID"

echo ""
echo "5. Creating public route table"

ROUTE_TABLE_ID="$(
  aws_cli ec2 create-route-table \
    --vpc-id "$VPC_ID" \
    --query 'RouteTable.RouteTableId' \
    --output text
)"

save_state \
  ROUTE_TABLE_ID \
  "$ROUTE_TABLE_ID"

tag_ec2_resource \
  "$ROUTE_TABLE_ID" \
  "${LAB_NAME}-public-rt"

aws_cli ec2 create-route \
  --route-table-id "$ROUTE_TABLE_ID" \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id "$INTERNET_GATEWAY_ID" \
  >/dev/null

ROUTE_TABLE_ASSOCIATION_ID="$(
  aws_cli ec2 associate-route-table \
    --route-table-id "$ROUTE_TABLE_ID" \
    --subnet-id "$SUBNET_ID" \
    --query AssociationId \
    --output text
)"

save_state \
  ROUTE_TABLE_ASSOCIATION_ID \
  "$ROUTE_TABLE_ASSOCIATION_ID"

echo "Route Table: $ROUTE_TABLE_ID"
echo "Association: $ROUTE_TABLE_ASSOCIATION_ID"

echo ""
echo "6. Creating Security Group"

SECURITY_GROUP_ID="$(
  aws_cli ec2 create-security-group \
    --group-name "${LAB_NAME}-web-sg" \
    --description \
      "HTTP from the current operator IP; no inbound SSH" \
    --vpc-id "$VPC_ID" \
    --query GroupId \
    --output text
)"

save_state \
  SECURITY_GROUP_ID \
  "$SECURITY_GROUP_ID"

tag_ec2_resource \
  "$SECURITY_GROUP_ID" \
  "${LAB_NAME}-web-sg"

aws_cli ec2 authorize-security-group-ingress \
  --group-id "$SECURITY_GROUP_ID" \
  --ip-permissions "$(
    jq -nc \
      --argjson port "$HTTP_PORT" \
      --arg cidr "$HTTP_ALLOWED_CIDR" \
      '[
        {
          IpProtocol: "tcp",
          FromPort: $port,
          ToPort: $port,
          IpRanges: [
            {
              CidrIp: $cidr,
              Description: "Current operator public IP"
            }
          ]
        }
      ]'
  )"

echo "Security Group: $SECURITY_GROUP_ID"

echo ""
echo "7. Effective inbound rules"

aws_cli ec2 describe-security-groups \
  --group-ids "$SECURITY_GROUP_ID" \
  --query \
    'SecurityGroups[0].IpPermissions'

echo ""
echo "Network provisioning completed."