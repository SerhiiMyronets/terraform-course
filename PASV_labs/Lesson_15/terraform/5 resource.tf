resource "aws_instance" "entity" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = data.aws_ec2_instance_types.c6a_large.instance_types[0]
  vpc_security_group_ids = [aws_security_group.entity_sg.id]
  key_name               = local.aws_key.file_name
  iam_instance_profile   = aws_iam_instance_profile.jenkins_profile_devops_en.name

  root_block_device {
    volume_size = 25
  }
  tags = {
    Name = "${local.entity_name} Instance"
  }
}
