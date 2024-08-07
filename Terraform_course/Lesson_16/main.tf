provider "aws" {}


variable "name" {
  default = "orest"
}

resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!@#$%^&*()_+-="
  keepers = {
    keeper = var.name
  }
}


resource "aws_ssm_parameter" "rds_password" {
  name        = "/rds/password"
  description = "Password for the RDS instance"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

data "aws_ssm_parameter" "smm_parameter_passwod" {
  name       = "/rds/password"
  depends_on = [aws_ssm_parameter.rds_password]
}

output "generated_password" {
  value = random_string.rds_password.result
}
output "smm_parameter_passwod" {
  value     = data.aws_ssm_parameter.smm_parameter_passwod.value
  sensitive = true
}

resource "aws_db_instance" "rds_test_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  identifier           = "rds-test"
  username             = "admin"
  password             = data.aws_ssm_parameter.smm_parameter_passwod.value
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  apply_immediately    = true
}
