terraform {
  backend "s3" {
    bucket = "devops-virginia1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}