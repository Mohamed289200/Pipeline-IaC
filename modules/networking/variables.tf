variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public1_cidr" {
  type        = string
  description = "CIDR block for public subnet 1"
}

variable "public2_cidr" {
  type        = string
  description = "CIDR block for public subnet 2"
}

variable "private1_cidr" {
  type        = string
  description = "CIDR block for private subnet 1"
}

variable "private2_cidr" {
  type        = string
  description = "CIDR block for private subnet 2"
}

variable "az1" {
  type        = string
  description = "Availability zone for subnet 1 (e.g. us-east-2a)"
}

variable "az2" {
  type        = string
  description = "Availability zone for subnet 2 (e.g. us-east-2b)"
}

variable "env" {
  type        = string
  description = "Deployment environment (dev | stag | prod)"
}