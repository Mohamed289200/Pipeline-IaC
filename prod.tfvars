# ── prod.tfvars ── Production Environment ────────────────────────

env    = "prod"
region = "us-east-2"

# Networking
vpc_cidr      = "10.2.0.0/16"
public1_cidr  = "10.2.1.0/24"
public2_cidr  = "10.2.2.0/24"
private1_cidr = "10.2.3.0/24"
private2_cidr = "10.2.4.0/24"
az1           = "us-east-2a"
az2           = "us-east-2b"

# Security – restrict SSH to a known bastion CIDR in production
ssh_cidr = "10.2.0.0/16"

# Compute
instance_type    = "t3.medium"
asg_desired      = 2
asg_min          = 2
asg_max          = 6
cpu_target_value = 60
