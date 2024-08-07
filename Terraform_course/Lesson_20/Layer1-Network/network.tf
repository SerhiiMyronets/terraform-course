#----------------------------------------------------------------
terraform {
  backend "s3" {
    bucket = "serhiibucket"
    key    = "dev/network/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {}
#----------------------------------------------------------------
variable "vpc_cider" {
  default = "10.0.0.0/16"
}
variable "env" {
  default = "dev"
}
variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}
#----------------------------------------------------------------
data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cider
  tags = {
    Name = "${var.env}-vpc"
  }
}
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.env}-gateway"
  }
}
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}
resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.env}-route-public-subnets"
  }
}
resource "aws_route_table_association" "public_route" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnet.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
#----------------------------------------------------------------
output "vpc_id" {
  value = aws_vpc.main.id
}
output "vpc_cider" {
  value = aws_vpc.main.cidr_block
}
output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}
