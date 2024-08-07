provider "aws" {}


resource "aws_iam_user" "user1" {
  name = "Orest"
}

variable "users_list" {
  type    = list(string)
  default = ["vasia", "kolia", "masha", "mush", "lola"]
}

resource "aws_iam_user" "list" {
  count = length(var.users_list)
  name  = element(var.users_list, count.index)
}

output "created_iam_users" {
  value = aws_iam_user.list
}

output "created_iam_users_ids" {
  value = aws_iam_user.list[*].id
}

output "created_iam_users_ids_arms" {
  value = [
    for x in aws_iam_user.list :
    "${x.arn} - ${x.id}"
  ]
}

output "created_iam_users_map" {
  description = "my map"
  value = {
    for u in aws_iam_user.list :
    u.unique_id => u.id
  }
}

output "created_iam_users_filtered_map" {
  value = [
    for u in aws_iam_user.list :
    u.name
    if length(u.name) <= 4
  ]
}





# ----------------------------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  tags = {
    Name = "server-${count.index + 1}"
  }
}


output "server_all" {
  value = {
    for server in aws_instance.servers :
    server.id => server.public_ip
  }
}
