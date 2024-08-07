terraform {
  backend "s3" {
    bucket = "serhiibucket"
    key    = "dev/servers/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {}
#----------------------------------------------------------------
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "serhiibucket"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}
data "aws_ami" "latest_ubuntu_usa" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*.1"]
  }
}
#----------------------------------------------------------------
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest_ubuntu_usa.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  subnet_id              = data.terraform_remote_state.network.outputs.public_subnets_id[0]
  user_data              = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
myip=$(ifconfig | grep 'inet ' | awk '{print $2}')
echo "<h1>Welcome to server! My IP is: $myip</h1>" > /var/www/html/index.html
EOF
  tags = {
    Name  = "Webserver"
    Owner = "Serhii Myronets"
  }
}
resource "aws_security_group" "test_sg" {
  name   = "Webserver security group"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.network.outputs.vpc_cider]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "webserver_sg"
    Owner = "Serhii Myronets"
  }
}
#----------------------------------------------------------------
output "security_group-id" {
  value = aws_security_group.test_sg.id
}
output "web_server_public_id" {
  value = aws_instance.web_server.public_ip
}
