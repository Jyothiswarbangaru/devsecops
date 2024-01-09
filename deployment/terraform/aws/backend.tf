terraform {
  backend "s3" {
    bucket = "fordevsecops1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}