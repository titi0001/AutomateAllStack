terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}
provider "aws" {
   profile = "default"
   region = var.region_aws
}

resource "aws_launch_template" "app_template" {
    image_id = "ami-0e83be366243f524a"
    instance_type = var.instancia
    key_name = var.key
    tags = {
      Name = "Terraform Ansible Python"
    }
    security_group_names = [ var.grup_sec ]
    user_data = filebase64("ansible.sh")
}
resource "aws_key_pair" "keyssh" {
  key_name = var.key
  public_key = file("${var.key}.pub")
}

resource "aws_autoscaling_group" "grupo" {
  availability_zones = [ "${var.region_aws}a", "${var.region_aws}b" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
    id = aws_launch_template.app_template.id
    version = "$Latest"
  }
  target_group_arns = [ aws_lb_target_group.alvoLoadBalancer.arn ]
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.region_aws}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.region_aws}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ]
}

resource "aws_default_vpc" "vpc" {
}

resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "alvoLoadBalancer"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.vpc.id
}

resource "aws_lb_listener" "entradaLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer.arn
  }
}

resource "aws_autoscaling_policy" "escala-Producao" {
  name = "terraform-escala"
  autoscaling_group_name = var.nomeGrupo
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}