terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }

  # backend "s3" {
  #   bucket = "terraform-state-oleksii"
  #   key    = "terraform_my_infra.tfstate"
  #   region = "us-east-1"
  # }

  required_version = ">= 1.3"
}

# provider "aws" {
#   region = "us-east-1"
#   access_key = ""
#   secret_key = ""
# }


resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"

  dynamic "ingress" {
    for_each = ["80", "443", "8080"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# output "ip" {
#   value = aws_instance.test_t2_micro.public_ip
# }
