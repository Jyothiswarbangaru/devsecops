terraform {
  backend "s3" {
    bucket = "eswarvirginia1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}