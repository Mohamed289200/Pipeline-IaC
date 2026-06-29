terraform {
  backend "s3" {
    bucket = "terraform-state-mohamed-2026"
    region = "us-east-2"
  }
}
