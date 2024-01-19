terraform {
  backend "s3" {
    bucket = "nani2"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}