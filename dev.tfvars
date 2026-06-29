# ── dev.tfvars ── Development Environment ─────────────────────────

env    = "dev"
region = "us-east-2"

# Networking
vpc_cidr      = "10.0.0.0/16"
public1_cidr  = "10.0.1.0/24"
public2_cidr  = "10.0.2.0/24"
private1_cidr = "10.0.3.0/24"
private2_cidr = "10.0.4.0/24"
az1           = "us-east-2a"
az2           = "us-east-2b"

# Security
ssh_cidr = "0.0.0.0/0"

# Compute
instance_type    = "t3.micro"
asg_desired      = 1
asg_min          = 1
asg_max          = 2
cpu_target_value = 80
