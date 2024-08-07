provider "aws" {
  region = var.region
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.test_t2_micro.id
}

resource "aws_instance" "test_t2_micro" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  monitoring             = var.detailed_monitoring
  tags                   = merge(var.common_tag, { Name = "test ec2 ${var.common_tag["environment"]}" })
}


resource "aws_security_group" "web-sg" {
  name = "My Security group"
  dynamic "ingress" {
    for_each = var.allow_ports
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
  tags = merge(var.common_tag, { Name = "test security group ${var.common_tag["environment"]}" })
}


