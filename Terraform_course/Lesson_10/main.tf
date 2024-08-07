provider "aws" {
}

data "aws_ami" "tatest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "test_ubuntu" {
  ami           = data.aws_ami.tatest_ubuntu.id
  instance_type = "t2.micro"

}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.tatest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.tatest_ubuntu.name
}
