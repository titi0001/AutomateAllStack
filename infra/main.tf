resource "aws_launch_template" "app_template" {
    image_id = "ami-0e83be366243f524a"
    instance_type = var.instancia
    key_name = var.key
    tags = {
      Name = "Terraform Ansible Python"
    }
    security_group_names = [ var.grup_sec ]
    user_data = var.producao ? filebase64("ansible.sh") : ""
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
  target_group_arns = var.producao ? [ aws_lb_target_group.alvoLoadBalancer[0].arn ] : []
}

resource "aws_autoscaling_schedule" "liga" {
  scheduled_action_name = "liga"
  min_size = 0
  max_size = 1
  desired_capacity = 1  
  start_time = timeadd(timestamp(), "10m")
  recurrence = "0 10 * * MON-Fri"
  autoscaling_group_name = aws_autoscaling_group.grupo
}

resource "aws_autoscaling_schedule" "desliga" {
  scheduled_action_name = "desliga"
  min_size = 0
  max_size = 1
  desired_capacity = 0 
  start_time = timeadd(timestamp(), "11m")
  recurrence = "0 21 * * MON-Fri"
  autoscaling_group_name = aws_autoscaling_group.grupo
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
  count = var.producao ? 1 : 0
}

resource "aws_default_vpc" "vpc" {
}

resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "alvoLoadBalancer"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.vpc.id
  count = var.producao ? 1 : 0
}

resource "aws_lb_listener" "entradaLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancer[0].arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer[0].arn
  }
  count = var.producao ? 1 : 0
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
  count = var.producao ? 1 : 0
}