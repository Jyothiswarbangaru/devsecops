terraform {
  backend "s3" {
    bucket = "virginia4"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}