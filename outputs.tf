# ── Networking Outputs ────────────────────────────────────────
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.networking.vpc_id
}

output "public_subnet_1" {
  description = "ID of public subnet 1"
  value       = module.networking.public_subnet_1
}

output "public_subnet_2" {
  description = "ID of public subnet 2"
  value       = module.networking.public_subnet_2
}

output "private_subnet_1" {
  description = "ID of private subnet 1"
  value       = module.networking.private_subnet_1
}

output "private_subnet_2" {
  description = "ID of private subnet 2"
  value       = module.networking.private_subnet_2
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.networking.nat_gateway_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.networking.internet_gateway_id
}

# ── Security Outputs ──────────────────────────────────────────
output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = module.security.alb_sg_id
}

output "ec2_sg_id" {
  description = "ID of the EC2 security group"
  value       = module.security.ec2_sg_id
}

# ── ALB Outputs ───────────────────────────────────────────────
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "target_group_arn" {
  description = "ARN of the ALB Target Group"
  value       = module.alb.target_group_arn
}

# ── Compute Outputs ───────────────────────────────────────────
output "web_server_id" {
  description = "Instance ID of the standalone web server"
  value       = module.compute.instance_id
}

output "web_server_public_ip" {
  description = "Public IP of the standalone web server"
  value       = module.compute.instance_public_ip
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.asg_name
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = module.compute.launch_template_id
}