locals {
  entity_name = "jenkins"
  ingress_rules = {
    port        = ["22", "8080"],
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress_rules = {
    port        = ["22", "80", "443"],
    protocol    = "tcp",
    cidr_blocks = ["0.0.0.0/0"]
  }
  aws_key = {
    file_name = "jenkins_keypair"
    address   = "/Users/serhiimyronets/.aws/"
  }
}
