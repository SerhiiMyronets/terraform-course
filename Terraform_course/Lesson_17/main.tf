provider "aws" {}

variable "env" {
  default = "stage"
}

variable "prod_owner" {
  default = "Serhii Myronets"
}

variable "no_prod" {
  default = "Else"
}

variable "ec2_type" {
  default = {
    "prod"  = "t2.micro"
    "dev"   = "t3.small"
    "stage" = "t2.medium"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}

resource "aws_instance" "my_sever" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = var.env == "prod" ? "t2.micro" : "t3.micro"

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.no_prod
  }
}

resource "aws_instance" "my_sever2" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = lookup(var.ec2_type, var.env)

  tags = {
    Name  = "${var.env}-server"
    Owner = var.env == "prod" ? var.prod_owner : var.no_prod
  }
}

resource "aws_instance" "my_dev" {
  count         = var.env == "prod" ? 1 : 0
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  tags = {
    Name = "my_dev"
  }
}

resource "aws_security_group" "web-sg" {
  name = "SecurityGroup"
  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env, [20])
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


output "name" {
  value = lookup(var.ec2_type, var.env)
}
output "name1" {
  value = var.ec2_type[var.env]
}
