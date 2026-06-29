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

# SSH Key Pair
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDzoQwSzU4eUZDb0nh+xigyrVjBtD4PFlIJciT8v6kyPLClGKVIceHYmwgbRSoTvaH6X/cW2frn+tU1Yz83xAhKH7+TDADTz/6jUcyYL4c5I02OEenb8EGvcrWiBdI0wppHwjlGfqVPCIZUqUblvQac/N8dEkxWfyS01BfyrPX56TpAuUDOftEGF7PLstmJ1JVA3UR25xwVaEB6tvOt3gsr3UUgpb6RW8CU2UcclMlRc4zHJU28MXXHCiNRpq7iI8INqi3h8li2PJZ1Dvmj9nw0LU+HsfEKPNbNmAOfj8TSYqlR2/q/LrNvCWLmEgOyil+cmNym5WmEnKBxS6ZXRDb69wWaoUI/szPoITDeaReecQODXp9mQF9OfJRcgnTZXIALFw3pOigphQo/ohnVyRtCnsj3l/eWfpSq39QjIJJHwms6RRtVpa+O9I5S7S4dPiS8a0WPMusi0V9mGOZtrSVmX1veZs27CTA96tW/ca41ajeAviFg1c4Q/x621akC6VE= root@DESKTOP-8E82I96"
# private_key_content is injected by Jenkins as TF_VAR_private_key_content env variable

