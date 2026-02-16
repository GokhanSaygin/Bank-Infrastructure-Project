provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "bank-terraform-state-1881" # <--- BURAYA KENDİ BUCKET ADINI YAZ
    key    = "bank-infra/terraform.tfstate"
    region = "us-east-1"
  }
}