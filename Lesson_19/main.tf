provider "aws" {
  region = "us-east-1"
  alias  = "usa"
}
provider "aws" {
  region = "ca-central-1"
  alias  = "canada"
}
# ----------------------------------------------------------------
data "aws_ami" "latest_ubuntu_usa" {
  provider    = aws.usa
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*.1"]
  }
}
data "aws_ami" "latest_ubuntu_canada" {
  provider    = aws.canada
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*.1"]
  }
}
# ----------------------------------------------------------------
resource "aws_instance" "my_defoul_instance1" {
  provider      = aws.usa
  ami           = data.aws_ami.latest_ubuntu_usa.id
  instance_type = "t2.micro"
  tags = {
    Name = "default aws_instance in US-east-1"
  }
}

resource "aws_instance" "my_defoul_instance2" {
  provider      = aws.canada
  ami           = data.aws_ami.latest_ubuntu_canada.id
  instance_type = "t2.micro"
  tags = {
    Name = "default aws_instance in Canada"
  }
}

