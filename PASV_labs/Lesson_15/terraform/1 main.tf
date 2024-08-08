terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
  }
  required_version = ">=1.3"
  backend "s3" {
    bucket = "serhiibucket"
    key    = "pasv/lesson_15/terraform.tfstate"
    region = "us-east-1"
  }
}
