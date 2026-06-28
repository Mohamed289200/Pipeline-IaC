variable "vpc_id" {
  type        = string
  description = "ID of the VPC in which to create the security groups"
}

variable "ssh_cidr" {
  type        = string
  description = "CIDR block allowed for SSH access to EC2 instances (e.g. your office IP /32)"
  default     = "0.0.0.0/0"
}

variable "env" {
  type        = string
  description = "Deployment environment (dev | stag | prod)"
}
