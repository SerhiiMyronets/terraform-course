variable "region" {
  description = "Please enter a region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Pease enter instance type"
  type        = string
  default     = "t2.micro"

}

variable "allow_ports" {
  description = "liest of ports to open for server"
  type        = list(string)
  default     = ["80", "443"]
}

variable "detailed_monitoring" {
  description = "Enable detailed monitoring for the instance"
  type        = bool
  default     = false
}

variable "common_tag" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Owner       = "Serhii Myronets"
    Project     = "Phenix"
    environment = "development"
  }
}


