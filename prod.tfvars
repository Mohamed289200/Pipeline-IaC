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

# SSH Key Pair
public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDzoQwSzU4eUZDb0nh+xigyrVjBtD4PFlIJciT8v6kyPLClGKVIceHYmwgbRSoTvaH6X/cW2frn+tU1Yz83xAhKH7+TDADTz/6jUcyYL4c5I02OEenb8EGvcrWiBdI0wppHwjlGfqVPCIZUqUblvQac/N8dEkxWfyS01BfyrPX56TpAuUDOftEGF7PLstmJ1JVA3UR25xwVaEB6tvOt3gsr3UUgpb6RW8CU2UcclMlRc4zHJU28MXXHCiNRpq7iI8INqi3h8li2PJZ1Dvmj9nw0LU+HsfEKPNbNmAOfj8TSYqlR2/q/LrNvCWLmEgOyil+cmNym5WmEnKBxS6ZXRDb69wWaoUI/szPoITDeaReecQODXp9mQF9OfJRcgnTZXIALFw3pOigphQo/ohnVyRtCnsj3l/eWfpSq39QjIJJHwms6RRtVpa+O9I5S7S4dPiS8a0WPMusi0V9mGOZtrSVmX1veZs27CTA96tW/ca41ajeAviFg1c4Q/x621akC6VE= root@DESKTOP-8E82I96"
private_key_path = "/root/.ssh/id_rsa"
