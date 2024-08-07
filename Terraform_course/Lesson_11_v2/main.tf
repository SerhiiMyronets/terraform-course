#----------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Owner : "Serhii Myronets"
      CreatedBy : "Terraform"
    }
  }
}
#----------------------------------------------------------------
data "aws_availability_zones" "active" {}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}
#----------------------------------------------------------------
resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.active.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.active.names[1]
}
#----------------------------------------------------------------
resource "aws_security_group" "web_sg" {
  name   = "Web Security Group"
  vpc_id = aws_default_vpc.default.id
  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 22
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Web Security Group"
  }
}
#----------------------------------------------------------------
resource "aws_launch_template" "web" {
  name                   = "Web_Launch_Template"
  image_id               = data.aws_ami.latest_amazon_linux.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = filebase64("user_data.sh")
}
#----------------------------------------------------------------
resource "aws_autoscaling_group" "web" {
  name                = "Web Autoscaling Group-Ver-${aws_launch_template.web.latest_version}"
  min_size            = 2
  max_size            = 2
  min_elb_capacity    = 2
  health_check_type   = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  target_group_arns   = [aws_lb_target_group.web.id]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  lifecycle {
    create_before_destroy = true
  }
}
#----------------------------------------------------------------
resource "aws_lb" "web" {
  name               = "Web-lb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
}

resource "aws_lb_target_group" "web" {
  name                 = "Web-lb-target-group"
  vpc_id               = aws_default_vpc.default.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}
