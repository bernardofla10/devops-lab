# EC2 Cost and Cleanup Checklist

## Before launch

- [ ] Monthly AWS budget exists
- [ ] Billing alerts are confirmed
- [ ] The Region is correct
- [ ] The instance type is intentional
- [ ] The root-volume size is intentional
- [ ] DeleteOnTermination is enabled
- [ ] No Elastic IP will be created
- [ ] No NAT Gateway will be created
- [ ] HTTP is restricted to one IP
- [ ] SSH is not exposed

## After launch

- [ ] EC2 state is known
- [ ] Public IPv4 is known
- [ ] EBS volume is encrypted
- [ ] SSM status is Online
- [ ] Nginx responds
- [ ] Tags are present
- [ ] Inventory report was generated

## End of study session

To continue the week:

```bash
./scripts/instance-lifecycle.sh stop
```

Remember:

- EC2 compute billing stops
- EBS storage remains
- the public IPv4 may change after start

## Full cleanup

```bash
./scripts/cleanup.sh --confirm
```

Confirm:

```text
instances: 0
volumes: 0
Security Groups: no lab group
VPCs: no lab VPC
```

## Resources that can remain billable

- running EC2 instances
- EBS volumes
- snapshots
- public IPv4 addresses
- Elastic IP addresses
- NAT Gateways
- load balancers
- CloudWatch log storage

## Rule

```text
stop when pausing
terminate when finished
verify volumes after termination
review billing after every lab
```