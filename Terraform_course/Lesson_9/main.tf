provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "current" {}

data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.0.0.0/24"
  tags = {
    Name    = "subnet ${data.aws_availability_zones.working.names[0]}"
    Account = "subnet in account ${data.aws_caller_identity.current.account_id}"
  }

}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names[0]
}
output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_region_name" {
  value = data.aws_region.current.name
}

output "data_region_description" {
  value = data.aws_region.current.description
}

output "data_aws_vpcs" {
  value = data.aws_vpcs.current.ids
}

output "data_aws_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "data_aws_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}
