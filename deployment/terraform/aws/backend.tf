terraform {
  backend "s3" {
    bucket = "eswarvirginia"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}