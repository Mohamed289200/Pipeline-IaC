variable "instance_type" {
  type        = string
  description = "EC2 instance type for web server and ASG instances"
  default     = "t3.micro"
}

variable "ec2_sg_id" {
  type        = string
  description = "ID of the EC2 security group"
}

variable "public_subnet_1" {
  type        = string
  description = "ID of public subnet 1 (used for EC2 and ASG)"
}

variable "public_subnet_2" {
  type        = string
  description = "ID of public subnet 2 (used for ASG)"
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB target group to attach the ASG to"
}

variable "public_key" {
  type        = string
  description = "Public SSH key for the EC2 key pair"
}

variable "private_key_content" {
  type        = string
  description = "Content of the private SSH key for remote provisioner (injected by Jenkins)"
  sensitive   = true
}

variable "asg_desired" {
  type        = number
  description = "Desired number of instances in the Auto Scaling Group"
  default     = 2
}

variable "asg_min" {
  type        = number
  description = "Minimum number of instances in the Auto Scaling Group"
  default     = 2
}

variable "asg_max" {
  type        = number
  description = "Maximum number of instances in the Auto Scaling Group"
  default     = 4
}

variable "cpu_target_value" {
  type        = number
  description = "Target CPU utilization percentage for the ASG scaling policy"
  default     = 70
}

variable "env" {
  type        = string
  description = "Deployment environment (dev | stag | prod)"
}
