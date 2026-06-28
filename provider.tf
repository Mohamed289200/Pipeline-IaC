terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state-mohamed-2026"
    # key is injected at init time via -backend-config in the Jenkinsfile:
    # terraform init -backend-config="key=${ENV}/terraform.tfstate"
    key    = "dev/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.region
}