provider "aws" {
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "echo Terrafrom START: $(date) >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping -c 5 www.google.com"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "const fs = require('fs'); fs.appendFileSync('log.txt', 'Run some js script\\n');"
    interpreter = ["node", "-e"]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 >> names.txt"
    environment = {
      NAME1 = "Vasia"
      NAME2 = "Petro"
      NAME3 = "Anna"
    }
  }
}

resource "null_resource" "command5" {
  provisioner "local-exec" {
    command = "echo Terrafrom END: $(date) >> log.txt"
  }
  depends_on = [null_resource.command1, null_resource.command2, null_resource.command3, null_resource.command4, aws_instance.my_server]
}

resource "aws_instance" "my_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS ec2 instance >> log.txt"
  }
}
