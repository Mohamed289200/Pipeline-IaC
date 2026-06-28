# ── General ──────────────────────────────────────────────────
variable "env" {
  type        = string
  description = "Deployment environment (dev | stag | prod)"
  default     = "dev"
}

variable "region" {
  type        = string
  description = "AWS region to deploy resources in"
  default     = "us-east-2"
}

# ── Networking ────────────────────────────────────────────────
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public1_cidr" {
  type        = string
  description = "CIDR block for public subnet 1"
  default     = "10.0.1.0/24"
}

variable "public2_cidr" {
  type        = string
  description = "CIDR block for public subnet 2"
  default     = "10.0.2.0/24"
}

variable "private1_cidr" {
  type        = string
  description = "CIDR block for private subnet 1"
  default     = "10.0.3.0/24"
}

variable "private2_cidr" {
  type        = string
  description = "CIDR block for private subnet 2"
  default     = "10.0.4.0/24"
}

variable "az1" {
  type        = string
  description = "Primary availability zone"
  default     = "us-east-2a"
}

variable "az2" {
  type        = string
  description = "Secondary availability zone"
  default     = "us-east-2b"
}

# ── Security ──────────────────────────────────────────────────
variable "ssh_cidr" {
  type        = string
  description = "CIDR block allowed to SSH into EC2 instances (use your IP /32)"
  default     = "0.0.0.0/0"
}

# ── Compute ───────────────────────────────────────────────────
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "public_key" {
  type        = string
  description = "Public SSH key content for the EC2 key pair"
  sensitive   = true
}

variable "private_key_path" {
  type        = string
  description = "Local path to the private SSH key used by the remote provisioner"
  sensitive   = true
}

variable "asg_desired" {
  type        = number
  description = "Desired number of EC2 instances in the ASG"
  default     = 2
}

variable "asg_min" {
  type        = number
  description = "Minimum number of EC2 instances in the ASG"
  default     = 2
}

variable "asg_max" {
  type        = number
  description = "Maximum number of EC2 instances in the ASG"
  default     = 4
}

variable "cpu_target_value" {
  type        = number
  description = "Target CPU utilization (%) for ASG target tracking policy"
  default     = 70
}