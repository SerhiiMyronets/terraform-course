provider "aws" {}

locals {
  full_project_name = "${var.environment}-${var.project_name}"
  project_owner     = "${var.owner} owner of ${var.project_name}"
  az_list           = join(",", data.aws_availability_zones.active.names)
  region            = data.aws_region.current.description
  location          = "In ${local.region} there are AZ: ${local.az_list}"

}

data "aws_region" "current" {}
data "aws_availability_zones" "active" {

}

resource "aws_eip" "my_statis_ip" {
  tags = {
    Name        = "Static IP"
    Owner       = local.project_owner
    Project     = local.full_project_name
    regions_AZs = local.az_list
    location    = local.location
  }
}
