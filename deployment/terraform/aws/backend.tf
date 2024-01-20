terraform {
  backend "s3" {
    bucket = "virginia3"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}