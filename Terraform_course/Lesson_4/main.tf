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

resource "aws_instance" "test_t2_micro" {
  # ami                    = "ami-0a0c8eebcdd6dcbd0" # ubuntu arm64 
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu amd64 (x86_64)
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = templatefile("test.sh.tpl", {
    firstName = "Serhii",
    lastName  = "Myronets"
    names     = ["Tetiana", "Orest"]
  })
  tags = {
    Name = "Testest again"
  }
}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ip" {
  value = aws_instance.test_t2_micro.public_ip
}
