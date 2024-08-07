data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "description"
    values = ["Canonical, Ubuntu, 24.04 LTS, amd64*"]
  }
}
data "aws_ec2_instance_types" "free_tier" {
  filter {
    name   = "free-tier-eligible"
    values = [true]
  }
}
data "aws_ec2_instance_types" "c6a_large" {
  filter {
    name   = "instance-type"
    values = ["c6a.large"]
  }
}
data "aws_vpc" "defaul" {
  default = true
}
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.defaul.id]
  }
}
data "aws_subnet" "subnets_details" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}
locals {
  all_subnets = data.aws_subnets.default.ids

  filtered_subnets = [
    for subnet_id in local.all_subnets : subnet_id
    if data.aws_subnet.subnets_details[subnet_id].availability_zone != "us-east-1e"
  ]
}


