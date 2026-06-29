# ── stag.tfvars ── Staging Environment ───────────────────────────

env    = "stag"
region = "us-east-2"

# Networking
vpc_cidr      = "10.1.0.0/16"
public1_cidr  = "10.1.1.0/24"
public2_cidr  = "10.1.2.0/24"
private1_cidr = "10.1.3.0/24"
private2_cidr = "10.1.4.0/24"
az1           = "us-east-2a"
az2           = "us-east-2b"

# Security
ssh_cidr = "0.0.0.0/0"

# Compute
instance_type    = "t3.small"
asg_desired      = 2
asg_min          = 2
asg_max          = 4
cpu_target_value = 70
