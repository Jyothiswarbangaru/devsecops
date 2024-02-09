terraform {
  backend "s3" {
    bucket = "oregonbucket2"
    key    = "eks/terraform.tfstate"
    region = "us-west-2"
  }
}