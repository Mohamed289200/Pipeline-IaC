variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "alb_sg_id" {
  type        = string
  description = "ID of the ALB security group"
}

variable "public_subnet_1" {
  type        = string
  description = "ID of public subnet 1 for ALB placement"
}

variable "public_subnet_2" {
  type        = string
  description = "ID of public subnet 2 for ALB placement"
}

variable "env" {
  type        = string
  description = "Deployment environment (dev | stag | prod)"
}
