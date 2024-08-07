terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
  }
  required_version = ">=1.3"
}

provider "aws" {
  default_tags {
    tags = {
      Enviroment = "Development"
      Owner      = "Serhii Myronets"
    }
  }
}
