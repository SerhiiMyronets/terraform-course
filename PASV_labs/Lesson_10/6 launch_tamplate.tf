resource "aws_launch_template" "web_lt" {
  name          = "web_launch_template"
  user_data     = filebase64("user_data.sh")
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = data.aws_ec2_instance_types.c6a_large.instance_types[0]
  key_name      = "ec2_keypair_mac"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "launch-tamplate-instance"
    }
  }
}




